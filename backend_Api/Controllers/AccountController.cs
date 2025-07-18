

using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Net;
using System.Net.Mail;
using backend_Api.Services;
using Microsoft.Extensions.Caching.Memory;

[ApiController]
[Route("accounts")]
public class AccountsController : ControllerBase
{
    private readonly AccountDb _db;
    private readonly IMemoryCache _cache;

    public AccountsController(IMemoryCache cache, AccountDb db)
    {
        _cache = cache;
        _db = db;
    }
    

    [HttpPost("send-confirmation-mail")]
    public async Task<IActionResult> SendConfirmationEmail([FromBody] Account account){
        try{
            if (!ModelState.IsValid)
                {
                    var errors = ModelState.Values
                        .SelectMany(v => v.Errors)
                        .Select(e => e.ErrorMessage)
                        .ToList();

                    return BadRequest(new { errors });
                }

            var existingAccount = await _db.Accounts.FirstOrDefaultAsync(acc => acc.Email == account.Email);
            if (existingAccount != null)
            {
                Console.WriteLine($"Un compte avec cet email existe déjà : {account.Email}");
                existingAccount.FirstName = account.FirstName;
                existingAccount.LastName = account.LastName;
                existingAccount.PhoneNumber = account.PhoneNumber;
                existingAccount.Company = account.Company;
                existingAccount.AcceptedTerms = account.AcceptedTerms;
                existingAccount.AgreedToContact = account.AgreedToContact;

                _db.Accounts.Update(existingAccount);
                await _db.SaveChangesAsync();
                return Conflict(new { message = "Compte mis à jour avec succès" });
                //return Conflict(new { message = "Un compte avec cet email existe déjà." });
            }    

            var ConfirmationToken = Guid.NewGuid().ToString();

            // Générer un code 6 chiffres
            var confirmationCode = new Random().Next(100000, 999999).ToString();

            var confirmationLink = $"conveydyn://confirm?token={ConfirmationToken}&email={account.Email}";
            var htmlBody = $"<p>Bonjour {account.FirstName},</p>" +
                        $"<p>Cliquez ici pour confirmer votre compte : " +
                        $"<a href=\"{confirmationLink}\">{confirmationLink}</a></p>";

            await EmailService.SendEmailAsync(account.Email, "Voici votre code de confirmation :", $"{confirmationCode} \n il s'agit d'un code de confirmation temporaire, veuillez le saisir dans l'application pour confirmer votre compte.");

            //await EmailService.SendEmailAsync(account.Email, "Confirmez votre email", 
            //<a href=$"http://localhost:5226/accounts/redirect?token={ConfirmationToken}&email={account.Email}">Confirmer mon compte</a>);

             // 3. (Optionnel mais recommandé) : enregistrer temporairement la demande
            var pendingAccount = new PendingAccount
            {
                Email = account.Email,
                FirstName = account.FirstName,
                LastName = account.LastName,
                Company = account.Company,
                PhoneNumber = account.PhoneNumber,
                AcceptedTerms = account.AcceptedTerms,
                AgreedToContact = account.AgreedToContact,
                Code = confirmationCode,
            };

            _cache.Set(confirmationCode, pendingAccount, TimeSpan.FromMinutes(30));

            //_db.PendingAccounts.Add(pending);
            //await _db.SaveChangesAsync();

            return Ok(new { message = "Email de confirmation envoyé." });
            
        }catch(Exception ex){
            // Log the exception (ex) here if needed
            return StatusCode((int)HttpStatusCode.InternalServerError, new { message = "Une erreur est survenue lors de l'envoi de l'email de confirmation." });
        }
    }

    [HttpPost("confirm-email")]
    public async Task<IActionResult> ConfirmEmail(string code, string email)
    {
        if(!_cache.TryGetValue(code, out PendingAccount? accountFromCache)){
            return BadRequest("Le code de confirmation a expiré ou est invalide.");
        }

         // Vérifie si l'email correspond
        if (accountFromCache.Email != email)
        {
            return BadRequest("Email ou token incorrect.");
        }

         // Crée le compte maintenant
        var account = new Account
        {
            FirstName = accountFromCache.FirstName,
            LastName = accountFromCache.LastName,
            Email = accountFromCache.Email,
            Company = accountFromCache.Company,
            PhoneNumber = accountFromCache.PhoneNumber,
            AcceptedTerms = accountFromCache.AcceptedTerms,
            AgreedToContact = accountFromCache.AgreedToContact,
        };

        _db.Accounts.Add(account);
        await _db.SaveChangesAsync();

        return Ok(new { message = "Code confirmer avec succées" });
    }


    [HttpDelete("{id}")]
    public async Task<IActionResult> Delete(int id){
        var account = await _db.Accounts.FindAsync(id);
        if(account==null){
            return NotFound(new { message = "Compte not found"});
        }

        _db.Accounts.Remove(account);
        await _db.SaveChangesAsync();
        return NoContent();
    }

    [HttpGet("get-by-email")]
    public async Task<IActionResult> GetUserByMail(string email){
        var account = await _db.Accounts.FirstOrDefaultAsync(acc => acc.Email == email);
        if(account == null){
            return NotFound(new { message = "account not found"});
        }
        return Ok(account);
    }

    [HttpPut("update-account")]
    public async Task<IActionResult> UpdateAccount([FromBody] Account account){
        var existingAccount = await _db.Accounts.FirstOrDefaultAsync(acc => acc.Email == account.Email);
        if(existingAccount == null){
            return NotFound(new { message = "account not found"});
        }
        existingAccount.FirstName = account.FirstName;
        existingAccount.LastName = account.LastName;
        existingAccount.PhoneNumber = account.PhoneNumber;
        existingAccount.Company = account.Company;
        existingAccount.AcceptedTerms = account.AcceptedTerms;
        existingAccount.AgreedToContact = account.AgreedToContact;

        _db.Accounts.Update(existingAccount);
        await _db.SaveChangesAsync();
        return Ok(new { message = "Compte mis à jour avec succès" });
    }
}

[ApiController]
[Route("send-result")]
public class EmailController : ControllerBase
{
    [HttpPost]
    public async Task<IActionResult> sendMail([FromBody] EmailRequest request){
        await EmailService.SendEmailAsync(request.To, request.Subject, request.Body);
        return Ok(new { message = "Email envoyé avec succès !" });
    }
}
