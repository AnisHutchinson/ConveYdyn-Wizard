using MailKit.Net.Smtp;
using MimeKit;



namespace backend_Api.Services
{
    public static class EmailService
    {
        public static async Task SendEmailAsync(string toEmail, string subject, string body)
        {
            var message = new MimeMessage();
            message.From.Add(new MailboxAddress("noreply", "noreply@hutchinsontransmission.com"));
            message.To.Add(new MailboxAddress("recever", toEmail));
            message.Subject = subject;

             var bodyBuilder = new BodyBuilder
            {
                HtmlBody = body
            };

            //var bodyBuilder = new BodyBuilder();
            //bodyBuilder.TextBody = body;
            //bodyBuilder.Attachments.Add(@"path\to\your\file.txt");
            message.Body = bodyBuilder.ToMessageBody();
            
            using var client = new SmtpClient();
            await client.ConnectAsync("smtp.gmail.com", 587, false); // ou true si SSL
            await client.AuthenticateAsync("anismekbal2001@gmail.com", "enzh ikrq rcar rucu"); // je dois pas mettre le mot de passe en dur dans le code, c'est juste un exemple
            await client.SendAsync(message);
            await client.DisconnectAsync(true);
        }
    }
}

