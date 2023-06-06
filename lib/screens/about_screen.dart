import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

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
                    child: const Text('img'),
                  ),
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('email'),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('name'),
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
                    Container(
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
                    Container(
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
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 15,
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.logout_outlined),
                          Text('로그아웃'),
                        ],
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
