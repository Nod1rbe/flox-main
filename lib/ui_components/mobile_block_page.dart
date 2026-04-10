import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';

@RoutePage()
class MobileBlockPage extends StatelessWidget {
  const MobileBlockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Iltimos, ushbu ilovani faqat kompyuter yoki laptopda oching.",
          style: TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
