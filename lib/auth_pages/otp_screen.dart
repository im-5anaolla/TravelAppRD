import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:travely/components/global_variables.dart';

import '../home/city_list_screen.dart';

class OTPScreen extends StatefulWidget {
  final String verificationId;

  const OTPScreen({super.key, required this.verificationId});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(
          top: screenHeight * 0.2,
        ),
        child: Column(
          children: [
            const Center(
              child: Text(
                'Code Verification',
                style: TextStyle(
                  fontFamily: 'SourceSans3',
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                ),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.02,
            ),
            const Text(
              'Enter the verification code we have sent to your phone',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: Colors.black45,
              ),
            ),
            SizedBox(
              height: screenHeight * 0.02,
            ),
            OtpTextField(
              numberOfFields: 6,
              fillColor: Colors.black.withOpacity(0.05),
              filled: true,
              onSubmit: (code) {
                print("OTP is: $code");
              },
            ),
            SizedBox(
              height: screenHeight * 0.02,
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.black54),
              ),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => CityListScreen()));
              },
              child: const Text(
                'Next',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// Start the phone verification process
Future<void> verifyPhone(String phoneNumber) async {
  verificationCompleted(PhoneAuthCredential credential) async {
    // Auto-retrieved (if enabled) or verified successfully
    UserCredential authResult =
        await FirebaseAuth.instance.signInWithCredential(credential);
    User user = authResult.user!;
    // Handle successful sign-in
  }

  verificationFailed(FirebaseAuthException e) {
    if (e.code == 'invalid-phone-number') {
      // Handle invalid phone number
    }
    // Handle other errors
  }

  codeSent(String verificationId, int? resendToken) {
    String smsCode = ''; // Get OTP input from the user
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: smsCode);
  }

  codeAutoRetrievalTimeout(String verificationId) {
    // Handle timeouts
  }

  await FirebaseAuth.instance.verifyPhoneNumber(
    phoneNumber: phoneNumber,
    verificationCompleted: verificationCompleted,
    verificationFailed: verificationFailed,
    codeSent: codeSent,
    codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
  );
}
