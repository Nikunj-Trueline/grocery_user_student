import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_user_student/views/register/register_screen.dart';
import 'package:grocery_user_student/widgets/custom_button.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerificationScreen extends StatefulWidget {
  final String verificationId;

  VerificationScreen({super.key, required this.verificationId});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final otpController = TextEditingController();

  bool isLoading = false;

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset("assets/veggie_bg.png"),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text(
                  "Verify your \n Mobile Number",
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                      fontWeight: FontWeight.w900),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: PinCodeTextField(
                  appContext: context,
                  length: 6,
                  controller: otpController,
                  keyboardType: TextInputType.number,
                  animationType: AnimationType.fade,
                  obscureText: false,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 50,
                    fieldWidth: 40,
                    activeColor: Colors.green,
                    disabledColor: Colors.blue,
                    activeFillColor: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: CustomButton(
                    title: "Verify and Continue",
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    callback: () {
                      if (formKey.currentState!.validate()) {
                        setState(() {
                          isLoading = true;
                        });
                        try {
                          PhoneAuthCredential phoneauthcredential =
                              PhoneAuthProvider.credential(
                                  verificationId: widget.verificationId,
                                  smsCode: otpController.text.toString());

                          FirebaseAuth.instance.signInWithCredential(phoneauthcredential).then((value){
                            if (phoneauthcredential != null) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RegisterScreen(),
                                  ));
                            }
                          });



                        } catch (e) {
                          log(e.toString());
                        }
                      }
                    },
                    isLoading: isLoading),
              )
            ],
          ),
        ),
      ),
    );
  }
}
