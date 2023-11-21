import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'otp_screen.dart';

class PhoneInputPage extends StatefulWidget {
  @override
  State<PhoneInputPage> createState() => _PhoneInputPageState();
}

class _PhoneInputPageState extends State<PhoneInputPage> {

  bool loading = false;
  final phoneNumberController = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify Phone Number'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Please verify your identity',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SourceSans3',

                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Container(
                //margin: EdgeInsets.all(10),
                padding: EdgeInsets.only(left: 20,),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white24,
                    border: Border.all(color: Colors.lightBlueAccent)
                ),
                child:  TextField(
                  controller: phoneNumberController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Enter Phone Number',
                    border: InputBorder.none,
                    //prefixText: '+92 - 3038315216',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  const SnackBar(content: CircularProgressIndicator());
                  auth.verifyPhoneNumber(
                    phoneNumber: phoneNumberController.text,
                      verificationCompleted: (_){
                      //Set loader to false if implemented.
                      },

                      verificationFailed: (e){
                      //set loader
                      print('Error: ${e.toString()}'
                      );
                      //set loader to false...
                      },
                      codeSent: (String verificationId, int? token){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => OTPScreen(verificationId: verificationId,)));
                      },
                      codeAutoRetrievalTimeout: (e){
                      print('Time Out: ${e.toString()}');
                      //set loader to false
                      });
                },
                child: Text('Send OTP'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}