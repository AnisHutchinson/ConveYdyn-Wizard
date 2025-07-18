using System.ComponentModel.DataAnnotations;
public class Account
{
    public int Id { get; set; }
    [Required]
    public string FirstName { get; set; }
    [Required]
    public string LastName { get; set; }
    [Required(ErrorMessage = "The email address is required")]
    [EmailAddress(ErrorMessage = "Invalid Email Address")]
    public string Email { get; set; }
    public string PhoneNumber { get; set; }
    [Required]
    public string Company { get; set; }
    [Required]
    public bool AcceptedTerms { get; set; }
    public bool AgreedToContact { get; set; }
    // ➕ Champs à ajouter pour confirmation d’email
}

  