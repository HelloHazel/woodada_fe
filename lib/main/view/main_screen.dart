import 'package:flutter/material.dart';
import 'package:woodada/main/component/main_card.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: MainCard(
        image: Image.asset(
          'asset/img/pet/pet1.jpg',
          fit: BoxFit.cover,
          width: 100.0,
          height: 100.0,
        ),
        name: "은경 매니저",
      )),
    );
  }
}
