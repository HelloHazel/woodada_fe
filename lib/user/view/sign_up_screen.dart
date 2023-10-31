import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nickNameController = TextEditingController();
  String _selectedAgeGroup = '18-24'; // Default age group
  DateTime? _selectedDate;
  String? _selectedGender;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    ))!;
    if (picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원 가입'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Center(
              child: CircleAvatar(
                // Your profile image here
                radius: 50,
                backgroundColor: Colors.grey,
                backgroundImage: NetworkImage(
                  'https://example.com/your-profile-image-url.jpg',
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _nickNameController,
              decoration: const InputDecoration(labelText: '닉네임'),
            ),
            const SizedBox(height: 16.0),
            DropdownButton<String>(
              value: _selectedAgeGroup,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedAgeGroup = newValue!;
                });
              },
              items: <String>[
                '18-24',
                '25-34',
                '35-44',
                '45-54',
                '55-64',
                '65+'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              hint: const Text('연령대 선택'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: const Text('생년월일 선택'),
            ),
            Text(_selectedDate != null
                ? '선택한 날짜: ${_selectedDate!.toLocal()}'.split(' ')[0]
                : '생년월일을 선택해주세요.'),
            const SizedBox(height: 16.0),
            Row(
              children: <Widget>[
                const Text('성별:'),
                Radio<String>(
                  value: '남성',
                  groupValue: _selectedGender,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  },
                ),
                const Text('남성'),
                Radio<String>(
                  value: '여성',
                  groupValue: _selectedGender,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  },
                ),
                const Text('여성'),
              ],
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Do something with the collected user data, e.g., save it to a database
                // You can access the values with _nickNameController.text, _selectedAgeGroup,
                // _selectedDate, and _selectedGender
              },
              child: const Text('가입하기'),
            ),
          ],
        ),
      ),
    );
  }
}
