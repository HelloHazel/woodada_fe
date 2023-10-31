import 'package:flutter/material.dart';
import 'package:woodada/common/layout/default_layout.dart';
import 'package:woodada/user/view/sign_up_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _showInitialPopup(); // initState 완료 후 팝업 표시
    });
  }

  void _showInitialPopup() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('어서오세요!'),
          content: const Text('앱에 오신 것을 환영합니다.'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignUpScreen(),
                  ),
                );
              },
              child: const Text('프로필 완성하고 서비스 시작하기'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const DefaultLayout(
      child: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [Text('메인')],
          ),
        ),
      ),
    );
  }
}
