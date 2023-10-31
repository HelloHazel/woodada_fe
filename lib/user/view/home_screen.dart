import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:woodada/common/layout/default_layout.dart';
import 'package:woodada/user/view/main_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLocationPermissionGranted = false;

  @override
  void initState() {
    super.initState();
    _checkLocationPermissionStatus();
  }

  Future<void> _checkLocationPermissionStatus() async {
    final status = await Permission.location.status;
    if (status.isGranted) {
      setState(() {
        isLocationPermissionGranted = true;
      });
    }
  }

  Future<void> _requestLocationPermission() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      setState(() {
        isLocationPermissionGranted = true;
        print('1');
      });
    } else {
      print("Location permission not granted: $status");
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 18.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Title(),
                const SizedBox(height: 20),
                _CheckBox(
                  isLocationPermissionGranted: isLocationPermissionGranted,
                  onRequestLocationPermission: _requestLocationPermission,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MainScreen(),
                      ),
                    );
                  },
                  child: const Text('시작하기'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          '환영합니다. \n아래 약관에 동의하시면 \n우다다 산책이 시작됩니다. ',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

class _CheckBox extends StatefulWidget {
  const _CheckBox({
    required this.isLocationPermissionGranted,
    required this.onRequestLocationPermission,
  });

  final bool isLocationPermissionGranted;
  final VoidCallback onRequestLocationPermission;

  @override
  _CheckBoxState createState() => _CheckBoxState(isLocationPermissionGranted);
}

class _CheckBoxState extends State<_CheckBox> {
  _CheckBoxState(this.isLocationAgreed);

  bool isAllAgreed = false;
  bool isLocationAgreed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Checkbox(
              value: isAllAgreed,
              onChanged: (value) {
                setState(() {
                  isAllAgreed = value!;
                  isLocationAgreed = value;
                });
                widget.onRequestLocationPermission();
              },
            ),
            const Text(
              '전체 동의',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ],
        ),
        const Divider(
          thickness: 1.0,
          color: Colors.grey,
          height: 0.0,
        ),
        Row(
          children: [
            Checkbox(
              value: isLocationAgreed,
              onChanged: (value) {
                setState(() {
                  isLocationAgreed = value!;
                });
                widget.onRequestLocationPermission();
              },
            ),
            const Text('위치 기반 서비스 약관 동의(필수)'),
          ],
        ),
      ],
    );
  }
}
