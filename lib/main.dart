import 'package:code_factory_app/common/component/custom_text_form_field.dart';
import 'package:code_factory_app/common/view/splash_screen.dart';
import 'package:code_factory_app/user/view/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    ProviderScope(
        child: _App(),
    )
  );
}

class _App extends StatelessWidget {
  const _App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'NotoSans'
      ),
      home: SplashScreen(),
    );
  }
}

