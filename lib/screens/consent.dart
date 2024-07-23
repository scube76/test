import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test/screens/phone_auth.dart';
import 'package:test/utils.dart';
import 'package:test/widgets/button.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Consent extends StatefulWidget {
  const Consent({super.key});

  @override
  State<Consent> createState() => _ConsentState();
}

class _ConsentState extends State<Consent> {
  bool loading = false;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  DatabaseReference databaseRef = FirebaseDatabase.instance.ref('Post');
  final auth = FirebaseAuth.instance;
  File? image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 40);
    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.green,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color.fromARGB(255, 0, 135, 5),
          foregroundColor: Colors.white,
          title: const Text('Consent Agreement'),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                auth.signOut().then((value) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PhoneAuth()));
                }).onError((error, stackTrace) {
                  Utils().toastMessage(error.toString());
                });
              },
              icon: const Icon(Icons.logout_outlined),
            ),
            const SizedBox(width: 10)
          ],
        ),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                '''We, the undersigned individuals, voluntarily agree to engage in consensual sexual activity with each other. We affirm that we are engaging in this activity willingly, without any coercion or undue influence.

We confirm that we are of legal age to engage in sexual activity according to the laws of our jurisdiction. We acknowledge that we are legally capable of giving consent to engage in sexual activity.

This consent is ongoing throughout our encounter. Either of us may withdraw consent at any time, and the other must respect that decision immediately.

By taking a picture together, we are agreeing to the above consent statement, we acknowledge that we have read and understood this consent statement and voluntarily agree to its terms.''',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: getImage,
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: image != null
                      ? Image.file(image!.absolute)
                      : const Icon(Icons.camera_alt_rounded),
                ),
              ),
              const SizedBox(height: 20),
              Button(
                  title: 'Submit',
                  loading: loading,
                  onTap: () async {
                    setState(() {
                      loading = true;
                    });

                    String id =
                        DateTime.now().millisecondsSinceEpoch.toString();

                    firebase_storage.Reference ref = firebase_storage
                        .FirebaseStorage.instance
                        .ref('/consentFiles/$id');
                    firebase_storage.UploadTask task =
                        ref.putFile(image!.absolute);

                    Future.value(task).then((value) async {
                      setState(() {
                        loading = false;
                      });
                      Utils().toastMessage('Consent submitted successfully');

                      // var url = await ref.getDownloadURL();
                      // databaseRef.child(id).set(
                      //     {'id': id, 'title': url.toString()}).then((value) {
                      //   setState(() {
                      //     loading = false;
                      //   });
                      //   Utils().toastMessage('Consent submitted successfully');
                      // }).onError((error, stackTrace) {
                      //   debugPrint(error.toString());
                      //   setState(() {
                      //     loading = false;
                      //   });
                      // });
                    }).onError((error, stackTrace) {
                      debugPrint(error.toString());
                      setState(() {
                        loading = false;
                      });
                    });
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
