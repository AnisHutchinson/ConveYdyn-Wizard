using Microsoft.EntityFrameworkCore;

using backend_Api.Services;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle

builder.Services.AddControllers();
//builder.Services.AddOpenApi();

//builder.Services.AddDbContext<AccountDb>(opt => opt.UseInMemoryDatabase("AccountList"));
//builder.Services.AddDatabaseDeveloperPageExceptionFilter();

builder.Services.AddDbContext<AccountDb>(opt => opt.UseSqlServer(
    builder.Configuration.GetConnectionString("DefaultConnection") ??
    throw new InvalidOperationException("Connection string 'DefaultConnection' not found.")));


builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Services.AddMemoryCache();

var app = builder.Build(); 

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

//app.UseHttpsRedirection();

app.MapGet("/accounts", async (AccountDb db) =>
    await db.Accounts.ToListAsync());

/*
app.MapPost("/accounts", async (Account account, AccountDb db) =>
{
    var existingAccount = await db.Accounts.FirstOrDefaultAsync(acc => acc.Email == account.Email);
    if (existingAccount != null)
    {
        return Results.Conflict(new {message = "account with this Email already existe"});
    }
    db.Accounts.Add(account);
    await db.SaveChangesAsync();
    return Results.Created($"/accounts/{account.Id}", account);
}
);*/

/*
app.MapDelete("/accounts/{id}", async (AccountDb db, int id) =>
{
    if (await db.Accounts.FindAsync(id) is Account account)
    {
        db.Accounts.Remove(account);
        await db.SaveChangesAsync();
        return Results.NoContent();
    }
    else return Results.NotFound("compte non trouvé");
});
*/
/*
app.MapPost("/send-result", async (EmailRequest request) =>
{
    await EmailService.SendEmailAsync(request.To, request.Subject, request.Body);
    return Results.Ok("Email envoyé !");
});
*/


//app.UseHttpsRedirection();
app.MapControllers();

app.Run();

public record EmailRequest(string To, string Subject, string Body);