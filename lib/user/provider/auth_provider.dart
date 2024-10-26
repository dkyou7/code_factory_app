import 'dart:math';

import 'package:code_factory_app/user/model/user_model.dart';
import 'package:code_factory_app/user/provider/user_me_provider.dart';
import 'package:code_factory_app/user/repository/user_me_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final authNotifier = ChangeNotifierProvider<AuthProvider>((ref) {
  return AuthProvider(ref: ref);
});

class AuthProvider extends ChangeNotifier {
  final Ref ref;

  AuthProvider({
    required this.ref,
  }){
    ref.listen<UserModelBase?>(userMeProvider, (previous,next){
      if(previous != next){
        notifyListeners();
      }
    });
  }

  /// SplashScreen 에서
  /// 토큰 존재 여부를 확인하고
  /// 로그인 페이지로 보낼 지
  /// 스플래시 화면으로 보낼 지 확인하는 과정
  String? redirectLogic(GoRouterState state){
    final UserModelBase? user = ref.read(userMeProvider);

    final logginIn = state.matchedLocation == '/login';

    /**
     * 사용자 정보가 없는데
     * 로그인 중이라면 그대로 로그인 페이지에 두고,
     * 로그인 중이 아니라면 로그인 페이지로 이동
     */
    if(user == null){
      return logginIn ? null : '/login';
    }

    /// 사용자 정보가 이미 있는 상태라면
    /// 로그인 중이거나 , 현재 위치가 SplashScreen 이면
    /// 홈으로 이동
    if(user is UserModel){
      return logginIn || state.matchedLocation == '/splash' ? '/' : null;
    }

    if(user is UserModelError){
      return !logginIn ? '/login' : null;
    }

    return null;
  }
}
