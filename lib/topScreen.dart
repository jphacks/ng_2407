import 'package:flutter/material.dart';

class MyTopScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CenteredTopScreen(),
    );
  }
}

class CenteredTopScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 200,
              width: 200,
              child: Image.asset('assets/logo_image.png'),
            ),
            // SizedBox(height: 20),
            Container(
              height: 80,
              width: 200,
              child: Image.asset('assets/logo_text.png'),
            ),
          ],
        ),
      ),
    );
  }
}
