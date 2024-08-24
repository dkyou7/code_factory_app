import 'package:code_factory_app/common/component/custom_text_form_field.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(_App());
}

class _App extends StatelessWidget {
  const _App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'NotoSans'
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextFormField(
              hintText: '이메일을 입력해주세요.',
              onChanged: (String value) {  },
            ),
            CustomTextFormField(
              hintText: '비밀번호를 입력해주세요.',
              onChanged: (String value) {  },
              obscureText: true,
            ),
          ],
        ),
      ),
    );
  }
}

