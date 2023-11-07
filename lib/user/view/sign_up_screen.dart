import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:woodada/common/components/custom_text_form_field.dart';
import 'package:woodada/common/layout/default_layout.dart';
import 'package:woodada/user/view/pet_sign_up_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nickNameController = TextEditingController();

  XFile? _pickedFile;

  @override
  Widget build(BuildContext context) {
    final imageSize = MediaQuery.of(context).size.width / 4;
    return DefaultLayout(
      title: '정보입력',
      child: Stack(
        children: [
          SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 16.0),
                    const Text(
                      '보호자 정보 입력',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    if (_pickedFile == null)
                      Container(
                        constraints: BoxConstraints(
                          minHeight: imageSize,
                          minWidth: imageSize,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            _showBottomSheet();
                          },
                          child: Center(
                            child: Icon(
                              Icons.account_circle,
                              size: imageSize,
                            ),
                          ),
                        ),
                      )
                    else
                      Center(
                        child: Container(
                          width: imageSize,
                          height: imageSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                width: 2,
                                color: Theme.of(context).colorScheme.primary),
                            image: DecorationImage(
                                image: FileImage(File(_pickedFile!.path)),
                                fit: BoxFit.cover),
                          ),
                        ),
                      ),
                    const SizedBox(height: 16.0),
                    const Text('닉네임 (필수)'),
                    const SizedBox(height: 8.0),
                    CustomTextFormField(
                      hintText: '닉네임',
                      onChanged: (String value) {},
                      obscureText: true,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 16.0),
                    const Text('활동지역'),
                    const SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        DropdownButton<String>(
                          value: '활동지역1',
                          onChanged: (String? newValue) {
                            // 여기서 선택된 값을 처리
                          },
                          items: <String>[
                            '활동지역1',
                            '활동지역2',
                            '활동지역3',
                            '활동지역4',
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        const SizedBox(width: 6.0),
                        DropdownButton<String>(
                          value: '활동지역2',
                          onChanged: (String? newValue) {
                            // 여기서 선택된 값을 처리
                          },
                          items: <String>[
                            '활동지역1',
                            '활동지역2',
                            '활동지역3',
                            '활동지역4',
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    const Text('자기소개 (선택)'),
                    const SizedBox(height: 8.0),
                    CustomTextFormField(
                      hintText: '자기소개를 입력하세요',
                      onChanged: (String value) {},
                      obscureText: false,
                      height: 150,
                      maxLines: 10,
                    ),
                    const SizedBox(height: 16.0),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: buildStartButton(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _showBottomSheet() {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () => _getCameraImage(),
              child: const Text('사진찍기'),
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(
              thickness: 3,
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () => _getPhotoLibraryImage(),
              child: const Text('라이브러리에서 불러오기'),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        );
      },
    );
  }

  _getCameraImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _pickedFile = pickedFile;
      });
    } else {
      if (kDebugMode) {
        print('이미지 선택안함');
      }
    }
  }

  _getPhotoLibraryImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedFile = _pickedFile;
      });
    } else {
      if (kDebugMode) {
        print('이미지 선택안함');
      }
    }
  }

  Widget buildStartButton() {
    return ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PetSignUpScreen(),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(300, 35), // 버튼의 최소 크기를 조절
        ),
        child: const Text('다음'));
  }
}
