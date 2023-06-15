import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:goodbible/models/push_notification_info.dart';
import 'package:goodbible/repositories/push_token_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  User? _user;
  bool _isLoggedIn = false;
  late PushInfo pushInfo;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    _firebaseMessaging.getToken().then((token) {
      print('Device Token: $token');
      // 여기에서 토큰을 사용하여 서버에 등록하거나 필요한 작업을 수행할 수 있습니다.
    });
  }

  bool _isNotificationEnabled = false;

  void settingNotification() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('푸시 알림 설정'),
          content: SwitchListTile(
            title: const Text('푸시 알림 받기'),
            value: _isNotificationEnabled,
            onChanged: (bool value) async {
              setState(() {
                _isNotificationEnabled = value;
              });

              // 푸시 알림 상태에 따른 동작 처리를 추가합니다.
              if (value) {
                // 알림을 켤 때 수행할 작업
                // 예: 토큰을 서버에 등록
                String? token = await _firebaseMessaging.getToken();
                print('Device Token: $token');
                pushInfo = PushInfo();
                pushInfo.token = token;
                pushInfo.userId = _user!.email;
                PushTokenCRUDRepository.save(pushInfo);
              } else {
                // 알림을 끌 때 수행할 작업
                // 예: 토큰을 서버에서 제거
                PushTokenCRUDRepository.remove(_user!.email!);
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('닫기'),
            ),
          ],
        );
      },
    );
  }

  // todo
  void shareApp() {}

  void _areYouSure() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("로그아웃"),
            actions: [
              TextButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    setState(() {
                      _isLoggedIn = false;
                    });
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AboutScreen(),
                      ),
                    );
                  },
                  child: const Text("네")),
              TextButton(onPressed: () {}, child: const Text("아니오")),
            ],
          );
        });
  }

  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    await FirebaseAuth.instance.signInWithCredential(credential);

    setState(() {
      _user = FirebaseAuth.instance.currentUser;
      _isLoggedIn = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: const Text(
          '정보',
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.w700,
          ),
        ),
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
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.network(
                                _user!.photoURL ?? "",
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Text("")),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _user != null
                            ? Text('${_user!.email}')
                            : const Text('이메일'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _user != null
                            ? Text('${_user!.displayName}')
                            : const Text('이름'),
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
                      //todo onTap: _isLoggedIn ? settingNotification : () {},
                      onTap: () {},
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
                              onTap: _areYouSure,
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
