import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:conveydyn_wizard/Service/DataManager.dart';
import 'package:conveydyn_wizard/Service/Interaction.dart';
import 'package:conveydyn_wizard/Service/SharedPref.dart';
import 'package:conveydyn_wizard/Utils/Inpute.dart';
import 'package:conveydyn_wizard/Utils/Shape.dart';
import 'package:conveydyn_wizard/Utils/constant.dart';
import 'package:conveydyn_wizard/Utils/helper.dart';

class Formwidget extends StatefulWidget {
  const Formwidget({super.key});

  @override
  State<Formwidget> createState() => _FormwidgetState();
}

class _FormwidgetState extends State<Formwidget> {
  final _formkey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();

  final _lastNameController = TextEditingController();

  final _companyController = TextEditingController();

  final _emailController = TextEditingController();

  final _phoneController = TextEditingController();

  late String label;

  bool showError = false;

    @override
  void initState() {
    super.initState();
    
    label = "REGISTRED";
  }


  @override
  Widget build(BuildContext context) {

    var DataProvider = Provider.of<DataManager>(context, listen: false);

    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
          width: math.max(300, 700),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Text(
                "To recieve your calculation results by mail please do fulfill these few data",
                style: TextStyle(fontFamily: 'CustomFont'),
              ),
              SizedBox(height: 10),
              Material(
                color: Colors.white,
                child: Form(
                  key: _formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Company *', style: TextStyle(fontSize: 16, fontFamily: 'CustomFont')),
                      SizedBox(height: 5),
                      TextFormField(
                        controller: _companyController,
                        decoration: customInputDecoration(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your Last name";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      Text('Last name *', style: TextStyle(fontSize: 16, fontFamily: 'CustomFont')),
                      SizedBox(height: 5),
                      TextFormField(
                        controller: _lastNameController,
                        decoration: customInputDecoration(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your Last name";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      Text('First name *', style: TextStyle(fontSize: 16, fontFamily: 'CustomFont')),
                      SizedBox(height: 5),
                      TextFormField(
                        controller: _firstNameController,
                        decoration: customInputDecoration(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your First name";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      Text('Email *', style: TextStyle(fontSize: 16, fontFamily: 'CustomFont')),
                      SizedBox(height: 5),
                      TextFormField(
                        controller: _emailController,
                        decoration: customInputDecoration(),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter an email address";
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return "Please enter a valide email address";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      Text('Phone number', style: TextStyle(fontSize: 16, fontFamily: 'CustomFont')),
                      SizedBox(height: 5),
                      IntlPhoneField(
                        controller: _phoneController,
                        keyboardType: TextInputType.number,
                        decoration: customInputDecoration(),
                        initialCountryCode: 'FR',
                        validator: (value) {
                          if (!RegExp(r'^\d+$').hasMatch(value.toString())) {
                            return "Please enter a valide number";
                          }
                        },
                      ),
                      SizedBox(height: 20),
                      FormField<bool>(
                        initialValue: DataProvider.acceptTerms,
                        validator: (value) {
                          if (value == null || !value) {
                            setState(() {
                              //showError = true;
                            }); 
                            return "";
                          }else{
                            setState(() {
                              //showError = false;
                            });
                            return null; // Pas d'erreur si la case est cochée
                          }
                        },
                        builder: (FormFieldState<bool> state){
                          return Stack(
                            //crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CheckboxListTile(
                                title: RichText(
                                  text: TextSpan(
                                    text: 'I have read and fully accept the ',
                                    style: TextStyle(
                                      fontFamily: "CustomFont",
                                      color: Colors.black,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: "General Terms and Conditions of Use",
                                        style: TextStyle(
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            HelpersFunct().launch_Url(
                                              Constant_Url().url_terms_of_use,
                                            );
                                          },
                                      ),
                                      TextSpan(
                                        text: " and the Hutchinson",
                                        style: TextStyle(
                                          fontFamily: "CustomFont",
                                          color: Colors.black,
                                        ),
                                      ),
                                      TextSpan(
                                        text: "Privacy Policy",
                                        style: TextStyle(
                                          fontFamily: 'CustomFont',
                                          decoration: TextDecoration.underline,
                                          color: const Color.fromARGB(255, 15, 34, 207),
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            HelpersFunct().launch_Url(
                                              Constant_Url().url_privacy_cookies,
                                            );
                                          },
                                      ),
                                    ],
                                  ),
                                ),
                                value: DataProvider.acceptTerms,
                                onChanged: (bool? value) {
                                  state.didChange(value); // Met à jour l'état du FormField
                                  //showError = !value!; // Met à jour l'état de showError
                                  DataProvider.updateAcceptTerms(value!);
                                },
                              ),
                              showError ?  Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0, // 👉 pour que le Row prenne toute la largeur
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center, // 👉 pour centrer le triangle
                                  children: const [
                                    ArrowUpTriangle(),
                                  ],
                                ),
                              ): Container(),
                            ],
                          );
                        }
                      ),
                      
                      Stack(
                        children: [
                          CheckboxListTile(
                            title: RichText(
                              text: TextSpan(
                                text:
                                    "I agree to be contacted by email at a later date by companies in the Hutchinson Group for information on new products, service and commercial offers",
                                style: TextStyle(
                                  fontFamily: "CustomFont",
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            value: DataProvider.agreeToContacte,
                            onChanged: (bool? value) {
                              setState(() {
                              });
                                DataProvider.updateAgreeToContact(value!);
                            },
                          ),
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0, // Centrage horizontal
                            //left: MediaQuery.of(context).size.width / 20,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [ Visibility(
                                visible: showError,
                                child: Container(
                                  width: 180,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                              
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF142559),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  child: const Text(
                                    "Please accept the General Terms and Conditions of Use and the Hutchinson Privacy Policy",
                                    style: TextStyle(fontFamily: 'CustomFont',color: Colors.white, fontSize: 12),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),],
                            ),
                          ),
                        ],
                      ),
                     
                      SizedBox(height: 20),
                      Center(
                        child: FilledButton.icon(
                          onPressed: () async{
                            bool isFormValid = _formkey.currentState!.validate();

                            if (!DataProvider.acceptTerms) {
                              setState(() {
                                showError = true;
                              });
                              Future.delayed(
                                  Duration(seconds: 3),
                                  () {
                                    setState(() {
                                      showError = false;
                                    });
                                  },
                                );
                              isFormValid = false;
                            }else{
                              showError = false;
                            }
                            if (isFormValid) {
                              
                              bool emailConfirmed = await sendAccount({
                                "Company": _companyController.text,
                                "FirstName": _firstNameController.text,
                                "LastName": _lastNameController.text,
                                "Email": _emailController.text,
                                "PhoneNumber": _phoneController.text,
                                "AcceptedTerms": DataProvider.acceptTerms,
                                "AgreedToContact": DataProvider.agreeToContacte,
                                /*"key":
                                    sha1dzd
                                        .convert(
                                          utf8.encode(
                                            "jean@example.comO.CaO,RIqY#7<3r",
                                          ),
                                        )
                                        .toString(),*/
                              }, context);
                              //Account account = await fetchUserByEmail(_emailController.text,);

                              // Enregistere les données dans DataProvider et SharedPref sauf que le compte est validé 
                              print("DataProvider.validEmail: ${DataProvider.validEmail}");
                              print(" EMAAAAAAAAAAAAAAAAIL: ${_emailController.text}");
                              print("DataProvider.email: ${DataProvider.email}");
                              
                              if(emailConfirmed == true){
                                setState(() {
                                  label = "YOUR ACCOUNT IS ACTIVATED";
                                });
                                
                                Future.delayed(
                                  Duration(seconds: 1),
                                  () {
                                    Navigator.of(context).pop();
                                  },
                                );
                                
                                DataProvider.updateLastName(
                                  _lastNameController.text,
                                );
                                DataProvider.updateFirstName(
                                  _firstNameController.text,
                                );
                                DataProvider.updateCompany(
                                  _companyController.text,
                                );
                                DataProvider.updateEmail(_emailController.text);
                                DataProvider.updateNumber(_phoneController.text);
                                int? phone = int.tryParse(_phoneController.text);
                                SharedPreferenceHelper().saveAccount(
                                  _companyController.text,
                                  _firstNameController.text,
                                  _lastNameController.text,
                                  _emailController.text,
                                  phone,
                                  // _phoneController.text as int,
                                );
                                DataProvider.updateValidEmail(false);

                                print("Email confirmed, account updated.  hakaaa  ${DataProvider.unit}");
                              }else{
                                print("Email not confirmed, please try again.");
                              }
                            }
                          },
                          style: ButtonStyle(
                            shape: ButtonStyleButton.allOrNull<
                              RoundedRectangleBorder
                            >(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              ),
                            ),
                            backgroundColor: ButtonStyleButton.allOrNull<Color>(
                              Colors.red,
                            ),
                            minimumSize: ButtonStyleButton.allOrNull<Size>(
                              Size(MediaQuery.of(context).size.width, 45),
                            ),
                          ),
                          // Définit des coins non arrond),
                          label: Text(
                            label,
                            style: TextStyle(
                              fontFamily: "CustomFont",
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          icon: Icon(Icons.check, color: Colors.white),
                          iconAlignment: IconAlignment.end,
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        "The personal data collected are processed under the responsibility of HUTCHINSON SA company, "
                        "in order to respond to your request for information and/or for commercial prospecting purposes. "
                        "Mandatory fields are marked with an asterisk. The legal basis for processing is your consent, "
                        "which you may withdraw at any time without affecting the lawfulness of processing based on consent before its withdrawal. "
                        "Personal data are reserved for the use of the HUTCHINSON group and may only be shared with other HUTCHINSON group companies "
                        "for commercial purposes if you have expressly consented to this.\n"
                        "In accordance with the regulations on personal data (GDPR), you have the right to access, rectify, and erase your personal data, "
                        "as well as the right to object to their processing. You may request the disclosure of your personal data and define guidelines "
                        "regarding their processing after your death. You also have the right to data portability, to restrict processing, and/or to file a complaint "
                        "with your local data protection authority (CNIL in France).",
                        style: TextStyle(fontFamily: "CustomFont"),
                      ),
                      SizedBox(height: 15),
                      Text(
                        "You can exercise your rights and ask us about the processing of your personal data by contacting us at the following email address:",
                        style: TextStyle(
                          fontFamily: "CustomFont",
                          color: Color.fromARGB(221, 71, 70, 70),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      GestureDetector(
                        onTap: () {
                          //OpenMail(); // donne le choix entre les apps installer
                          HelpersFunct().launch_Url(Constant_Url().emailData);
                        },
                        child: Text(
                          "data.protection@hutchinson.com",
                          style: TextStyle(
                            fontFamily: "CustomFont",
                            fontWeight: FontWeight.w600,
                            color: const Color.fromARGB(255, 6, 71, 124),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        "To fin out more:",
                        style: TextStyle(
                          fontFamily: "CustomFont",
                          color: Color.fromARGB(221, 71, 70, 70),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      GestureDetector(
                        onTap: () {
                          HelpersFunct().launch_Url(
                            Constant_Url().url_site_web,
                          );
                        },
                        child: Text(
                          "hutchinsontransmission.com",
                          style: TextStyle(
                            fontFamily: "CustomFont",
                            fontWeight: FontWeight.w600,
                            color: const Color.fromARGB(255, 6, 71, 124),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}