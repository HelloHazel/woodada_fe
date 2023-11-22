import 'dart:io';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:woodada/common/components/custom_text_form_field.dart';
import 'package:woodada/common/layout/default_layout.dart';
import 'package:woodada/user/view/main_screen.dart';
import 'package:woodada/common/view/root_tab.dart';
import 'package:woodada/user/view/web_view_screen.dart';

class PetSignUpScreen extends StatefulWidget {
  const PetSignUpScreen({Key? key}) : super(key: key);

  @override
  State<PetSignUpScreen> createState() => _PetSignUpScreenState();
}

class _PetSignUpScreenState extends State<PetSignUpScreen> {
  final TextEditingController _nickNameController = TextEditingController();
  String selectedGender = "Female";
  XFile? _pickedFile;
  bool isNeutered = true; // 초기값: 안했어요
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
                        '반려동물 정보 입력',
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
                      const Text('반려견 이름 (필수)'),
                      const SizedBox(height: 8.0),
                      CustomTextFormField(
                        hintText: '코코',
                        onChanged: (String value) {},
                        obscureText: true,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 16.0),
                      const Text('나이 (필수)'),
                      const SizedBox(height: 8.0),
                      CustomTextFormField(
                        hintText: '2살',
                        onChanged: (String value) {},
                        obscureText: true,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 16.0),
                      const Text('성별'),
                      const SizedBox(height: 8.0),
                      PetGender(
                        selectedGender: selectedGender,
                        onChanged: (value) {
                          setState(() {
                            selectedGender = value; // 선택된 성별 업데이트
                          });
                        },
                      ),
                      const SizedBox(height: 16.0),
                      const Text('중성화 여부'),
                      const SizedBox(height: 8.0),
                      IsNeutering(
                        isNeutered: isNeutered,
                        onChanged: (value) {
                          setState(() {
                            isNeutered = value; // 선택된 중성화 여부 업데이트
                          });
                        },
                      ),
                      const SizedBox(height: 16.0),
                      const Text('몸무게'),
                      const SizedBox(height: 8.0),
                      Row(
                        children: [
                          Expanded(
                            flex: 8,
                            child: CustomTextFormField(
                              hintText: '2.5',
                              onChanged: (String value) {},
                              obscureText: true,
                              maxLines: 1,
                            ),
                          ),
                          const Spacer(),
                          const Expanded(
                            flex: 2,
                            child: Text(
                              'kg',
                              style: TextStyle(fontSize: 16), // 원하는 스타일로 설정하세요.
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      const SizedBox(height: 16.0),
                      const Text('성격 또는 특징 (선택)'),
                      const SizedBox(height: 8.0),
                      CustomTextFormField(
                        hintText: '예시) 우리 댕댕이는 소형견이지만 힘이 셉니다',
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
                    ]),
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
              builder: (context) => const MainScreen(),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(300, 35), // 버튼의 최소 크기를 조절
        ),
        child: const Text('수정'));
  }
}

class PetGender extends StatefulWidget {
  final String selectedGender;
  final ValueChanged<String> onChanged;

  const PetGender(
      {super.key, required this.selectedGender, required this.onChanged});

  @override
  State<PetGender> createState() => _PetGender();
}

class _PetGender extends State<PetGender> {
  @override
  Widget build(BuildContext context) {
    return CustomRadioButton(
      buttonLables: const [
        "여아", // 여자
        "남아", // 남자
      ],
      buttonValues: const [
        "Female",
        "Male",
      ],
      radioButtonValue: (value) {
        widget.onChanged(value); // 선택된 성별 업데이트
      },
      selectedColor: Colors.blue, // 선택된 버튼 색상
      selectedBorderColor: Colors.blue,
      unSelectedColor: Colors.white, // 선택되지 않은 버튼 색상
      unSelectedBorderColor: Colors.grey,
      spacing: 0, // 각 라디오 버튼 사이의 간격
      enableShape: false,
      elevation: 0,
      width: MediaQuery.of(context).size.width / 2.6,
    );
  }
}

class IsNeutering extends StatefulWidget {
  final bool isNeutered; // 수정된 부분: bool로 변경
  final ValueChanged<bool> onChanged; // 수정된 부분: bool로 변경

  const IsNeutering({
    Key? key,
    required this.isNeutered,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<IsNeutering> createState() => _IsNeutering();
}

class _IsNeutering extends State<IsNeutering> {
  @override
  Widget build(BuildContext context) {
    return CustomRadioButton(
      buttonLables: const ["했어요", "안했어요"],
      buttonValues: const [true, false], // 수정된 부분: bool로 변경
      radioButtonValue: (value) {
        widget.onChanged(value); // 선택된 중성화 여부 업데이트
      },
      selectedColor: Colors.blue, // 선택된 버튼 색상
      selectedBorderColor: Colors.blue,
      unSelectedColor: Colors.white, // 선택되지 않은 버튼 색상
      unSelectedBorderColor: Colors.grey,
      spacing: 0, // 각 라디오 버튼 사이의 간격
      enableShape: false,
      elevation: 0,
      width: MediaQuery.of(context).size.width / 2.6,
    );
  }
}
