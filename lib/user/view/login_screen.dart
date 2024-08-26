import 'dart:convert';
import 'dart:io';

import 'package:code_factory_app/common/component/custom_text_form_field.dart';
import 'package:code_factory_app/common/layout/default_layout.dart';
import 'package:code_factory_app/common/const/colors.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dio = Dio();

    // localhost
    const emulatorIp = '10.0.2.2:3000';
    const simulatorIp = '127.0.0.1:3000';

    final ip = Platform.isIOS ? simulatorIp : emulatorIp;

    return DefaultLayout(
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SafeArea(
          top: true,
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Title(),
                const SizedBox(height: 16,),
                _SubTitle(),
                Image.asset(
                  'asset/img/misc/logo.png',
                  width: MediaQuery.of(context).size.width / 3 * 2,
                  height: MediaQuery.of(context).size.height / 3,
                ),
                const SizedBox(height: 16,),
                CustomTextFormField(
                  hintText: '이메일을 입력해주세요.',
                  onChanged: (String value) {},
                ),
                const SizedBox(height: 16,),
                CustomTextFormField(
                  hintText: '비밀번호를 입력해주세요.',
                  onChanged: (String value) {},
                  obscureText: true,
                ),
                const SizedBox(height: 16,),
                ElevatedButton(
                  onPressed: () async {
                    // ID:비밀번호
                    const rawString = 'test@codefactory.ai:testtest';

                    Codec<String, String> stringToBase64 = utf8.fuse(base64);

                    String token = stringToBase64.encode(rawString);

                    final resp = await dio.post(
                      'http://$ip/auth/login',
                      options: Options(
                        headers: {
                          'authorization': 'Basic $token',
                        },
                      ),
                    );

                    if (kDebugMode) {
                      print(resp.data);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PRIMARY_COLOR,
                    foregroundColor: Colors.white
                  ),
                  child: Text(
                    '로그인',
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    final refreshToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6InRlc3RAY29kZWZhY3RvcnkuYWkiLCJzdWIiOiJmNTViMzJkMi00ZDY4LTRjMWUtYTNjYS1kYTlkN2QwZDkyZTUiLCJ0eXBlIjoicmVmcmVzaCIsImlhdCI6MTcyNDY0OTI3NiwiZXhwIjoxNzI0NzM1Njc2fQ.nrj8zYY8_MYB0rGNz2KPBazXCj2v6loV9jVVDVfasL4';
                    final resp = await dio.post('http://$ip/auth/token',
                      options: Options(
                        headers: {
                          'authorization': 'Bearer $refreshToken',
                        },
                      ),
                    );

                    print(resp.data);
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                  ),
                  child: Text(
                    '회원가입',
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

class _Title extends StatelessWidget {
  const _Title({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      '환영합니다!',
      style: TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );
  }
}

class _SubTitle extends StatelessWidget {
  const _SubTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      '이메일과 비밀번호를 입력해서 로그인 해주세요!\n오늘도 성공적인 주문이 되길 :)',
      style: TextStyle(
        fontSize: 16,
        color: BODY_TEXT_COLOR,
      ),
    );
  }
}
