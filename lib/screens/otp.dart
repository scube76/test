import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test/screens/consent.dart';
import 'package:test/utils.dart';
import 'package:test/widgets/button.dart';

class Otp extends StatefulWidget {
  final String verificationId;
  const Otp({required this.verificationId, super.key});

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  bool loading = false;
  final otpController = TextEditingController();
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  labelStyle: TextStyle(color: Colors.white),
                  hintText: '6 digit verification code',
                ),
                controller: otpController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              Button(
                title: 'Verify OTP',
                loading: loading,
                onTap: () async {
                  setState(() {
                    loading = true;
                  });

                  final credential = PhoneAuthProvider.credential(
                    verificationId: widget.verificationId,
                    smsCode: otpController.text,
                  );
                  try {
                    await auth.signInWithCredential(credential);
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const Consent()));
                  } catch (e) {
                    setState(() {
                      loading = false;
                    });
                    Utils().toastMessage(e.toString());
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
