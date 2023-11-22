import 'package:flutter/material.dart';
import 'package:woodada/common/layout/default_layout.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '메인',
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            label: '메이트',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assistant_rounded),
            label: '매니저',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_outlined),
            label: '채팅',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_outlined),
            label: '마이페이지',
          ),
        ],
      ),
      child: const Center(
        child: Text('Root tab'),
      ),
    );
  }
}
