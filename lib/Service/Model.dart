class Account {
  final String Firstname;
  final String Lastname;
  final String Email;
  final String PhoneNumber;
  final String Company;
  final bool AcceptedTerms;
  final bool AgreedToContact;

  Account({required this.Email, required this.Firstname, required this.Lastname, required this.Company, required this.PhoneNumber, required this.AcceptedTerms, this.AgreedToContact = false});

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      Firstname: json['firstName'],
      Lastname: json['lastName'], 
      Email: json['email'],
      Company: json['company'],
      PhoneNumber: json['phoneNumber'],
      AcceptedTerms: json['acceptedTerms'],
      AgreedToContact: json['agreedToContact'],
    );
  }
}