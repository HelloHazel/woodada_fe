import 'package:flutter/material.dart';
import 'package:woodada/common/const/colors.dart';
import 'package:woodada/common/layout/default_layout.dart';
import 'package:woodada/main/view/main_screen.dart';
import 'package:woodada/user/view/sign_up_screen.dart';

class RootTab extends StatefulWidget {
  const RootTab({Key? key}) : super(key: key);

  @override
  _RootTabState createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> with SingleTickerProviderStateMixin {
  late TabController _controller;
  int index = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _showInitialPopup(); // initState 완료 후 팝업 표시
    });

    _controller = TabController(length: 5, vsync: this);

    _controller.addListener(tabListener);
  }

  void tabListener() {
    setState(() {
      index = _controller.index;
    });
  }

  @override
  void dispose() {
    _controller.removeListener(tabListener);
    _controller.dispose();
    super.dispose();
  }

  void _showInitialPopup() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('꽃길만 걷는 우리, \n우다다에 오신 것을 환영해요!'),
          content:
              const Text('보호자님과 반려견 프로필 정보를 입력하면 \n더 많은 우다다 서비스를 이용할 수 있어요.'),
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
    return DefaultLayout(
      title: '메인',
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: PRIMARY_COLOR,
        unselectedItemColor: BODY_TEXT_COLOR,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          _controller.animateTo(index);
        },
        currentIndex: index,
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
      child: TabBarView(
        controller: _controller,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const MainScreen(),
          Center(child: Container(child: const Text('메이트'))),
          Center(child: Container(child: const Text('매니저'))),
          Center(child: Container(child: const Text('채팅'))),
          Center(child: Container(child: const Text('마이페이지'))),
        ],
      ),
    );
  }
}
