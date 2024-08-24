import 'package:code_factory_app/common/component/custom_text_form_field.dart';
import 'package:code_factory_app/common/layout/default_layout.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomTextFormField(
            hintText: '이메일을 입력해주세요.',
            onChanged: (String value) {},
          ),
          CustomTextFormField(
            hintText: '비밀번호를 입력해주세요.',
            onChanged: (String value) {},
            obscureText: true,
          ),
        ],
      ),
    );
  }
}