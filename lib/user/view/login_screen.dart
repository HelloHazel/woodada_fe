import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:woodada/common/const/login_platform.dart';
import 'package:woodada/common/layout/default_layout.dart';
import 'package:woodada/user/view/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  LoginPlatform _loginPlatform = LoginPlatform.none;
  //dio를 이용한 kakao 긴편로그인 로직

  bool _isLogin = false;
  String nickName = "";
  String email = "";
  String ageRange = "";
  String gender = "";
  String accessToken = "";
  String refreshToken = "";
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> Login() async {
    // 두 번째 API 호출

    final dio = Dio();

    try {
      Map<String, dynamic> requestData;

      print('1');

      switch (_loginPlatform) {
        case LoginPlatform.kakao:
          requestData = {
            'email': email,
            'nickname': nickName,
            'ageRange': ageRange.replaceAll('~', '-'),
            'gender': gender == 'female' ? 'F' : 'M',
            'provider': _loginPlatform.toString().split('.').last,
          };
          break;
        case LoginPlatform.naver:
          requestData = {
            'email': email,
            'nickname': nickName,
            'ageRange': ageRange,
            'gender': gender,
            'provider': _loginPlatform.toString().split('.').last,
          };
          break;
        case LoginPlatform.none:
          requestData = {
            'a': 1,
          };
          break;
      }

      print('2 : $requestData');

      Options options = Options(
        headers: {'Content-Type': 'application/json'},
      );

      final secondApiResponse = await dio.post(
        'http://10.0.2.2:8080/auth/token',
        data: jsonEncode(requestData),
        options: options,
      );

      print('3 : $secondApiResponse');

      if (secondApiResponse.statusCode == 200) {
        setState(() {
          _isLogin = true;
          accessToken = secondApiResponse.data['accessToken'];
          refreshToken = secondApiResponse.data['refreshToken'];
        });
      } else {
        print('로그인 실패 처리');
      }
    } catch (error) {
      print('API 실패 $error');
    }
  }

  void signInWithKakao() async {
    try {
      bool isInstalled = await isKakaoTalkInstalled();

      OAuthToken token = isInstalled
          ? await UserApi.instance.loginWithKakaoTalk()
          : await UserApi.instance.loginWithKakaoAccount();

      final dio = Dio();
      dio.options.headers[HttpHeaders.authorizationHeader] =
          'Bearer ${token.accessToken}';

      final response = await dio.get('https://kapi.kakao.com/v2/user/me');

      if (response.statusCode == 200) {
        final profileInfo = response.data;
        print(profileInfo.toString());
        setState(() {
          _loginPlatform = LoginPlatform.kakao;
          email = profileInfo['kakao_account']['email'];
          nickName = profileInfo['properties']['nickname'];
          ageRange = profileInfo['kakao_account']['age_range'];
          gender = profileInfo['kakao_account']['gender'];
        });

        await Login().then((value) => {
              if (accessToken != "")
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const HomeScreen()), // Home.dart의 화면으로 이동
                  )
                }
            });
      } else {
        print('카카오 API 요청 실패: ${response.statusCode}');
      }
    } catch (error) {
      print('카카오톡으로 로그인 실패 $error');
      print(await KakaoSdk.origin);
    }
  }

  void signInWithNaver() async {
    final NaverLoginResult result = await FlutterNaverLogin.logIn();

    if (result.status == NaverLoginStatus.loggedIn) {
      print('accessToken = ${result.accessToken}');
      print('id = ${result.account.id}');
      print('email = ${result.account.email}');
      print('name = ${result.account.name}');

      setState(() {
        _loginPlatform = LoginPlatform.naver;
        email = result.account.email;
        nickName = result.account.nickname;
        ageRange = result.account.age;
        gender = result.account.gender;
      });

      await Login().then((value) => {
            if (accessToken != "")
              {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const HomeScreen()), // Home.dart의 화면으로 이동
                )
              }
          });
    }
  }

  void signOut() async {
    switch (_loginPlatform) {
      case LoginPlatform.kakao:
        signInWithKakao();
        break;
      case LoginPlatform.naver:
        await FlutterNaverLogin.logOut();
        break;
      case LoginPlatform.none:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: SingleChildScrollView(
        child: SafeArea(
          top: true,
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _TItle(),
                const SizedBox(
                  height: 10,
                ),
                const _SubTitle(),
                Image.asset(
                  'asset/img/misc/logo.png',
                  width: MediaQuery.of(context).size.width / 3 * 2,
                ),
                const SizedBox(
                  height: 45,
                ),
                InkWell(
                  onTap: signInWithKakao,
                  child: Image.asset(
                    'asset/login_button/kakao_btn.png',
                    height: 65,
                  ),
                ),
                const SizedBox(width: 5),
                InkWell(
                  onTap: signInWithNaver,
                  child: Image.asset(
                    'asset/login_button/naver_btn.png',
                    height: 65,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TItle extends StatelessWidget {
  const _TItle();

  @override
  Widget build(BuildContext context) {
    return const Text(
      '꽃길만 걷자, 우리',
      style: TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );
  }
}

class _SubTitle extends StatelessWidget {
  const _SubTitle();

  @override
  Widget build(BuildContext context) {
    return const Text(
      '우다다!',
      style: TextStyle(
        fontSize: 42,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );
  }
}
