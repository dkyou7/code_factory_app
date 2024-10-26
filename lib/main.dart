import 'package:code_factory_app/common/component/custom_text_form_field.dart';
import 'package:code_factory_app/common/view/splash_screen.dart';
import 'package:code_factory_app/user/provider/auth_provider.dart';
import 'package:code_factory_app/user/provider/go_router.dart';
import 'package:code_factory_app/user/repository/auth_repository.dart';
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

class _App extends ConsumerWidget {
  const _App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'NotoSans'
      ),
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
    );
  }
}

