import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  User? _user;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
  }

  void settingNotification() {}

  void shareApp() {}


  Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 20,
              ),
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(40)),
              child: Row(
                children: [
                  Container(
                      margin: const EdgeInsets.fromLTRB(
                        0,
                        0,
                        20,
                        0,
                      ),
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.black,
                      ),
                      child: _user != null
                          ? Image.network(_user!.photoURL ?? "")
                          : const Text("")),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _user != null
                            ? Text('${_user!.email}')
                            : const Text('email'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _user != null
                            ? Text('${_user!.displayName}')
                            : const Text('name'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 15,
              ),
              child: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(50)),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: settingNotification,
                      child: Container(
                        decoration: BoxDecoration(
                          border: BorderDirectional(
                            bottom: BorderSide(
                              color: Colors.black.withOpacity(0.1),
                              width: 1,
                            ),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 15,
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.notifications_outlined),
                              Text('알림'),
                            ],
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: shareApp,
                      child: Container(
                        decoration: BoxDecoration(
                          border: BorderDirectional(
                            bottom: BorderSide(
                              color: Colors.black.withOpacity(0.1),
                              width: 1,
                            ),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 15,
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.share_outlined),
                              Text('공유'),
                            ],
                          ),
                        ),
                      ),
                    ),
                     Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 15,
                        ),
                        child: _user != null
                            ? GestureDetector(
                              onTap: FirebaseAuth.instance.signOut,
                              child: const Row(
                                  children: [
                                    Icon(Icons.logout_outlined),
                                    Text('로그아웃'),
                                  ],
                                ),
                            )
                            : GestureDetector(
                              onTap: signInWithGoogle,
                              child: const Row(
                                  children: [
                                    Icon(Icons.login_outlined),
                                    Text('로그인'),
                                  ],
                                ),
                            ),
                      ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
