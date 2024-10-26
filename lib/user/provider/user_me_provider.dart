import 'package:code_factory_app/common/const/data.dart';
import 'package:code_factory_app/user/model/user_model.dart';
import 'package:code_factory_app/user/repository/auth_repository.dart';
import 'package:code_factory_app/user/repository/user_me_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserMeStateNotifier extends StateNotifier<UserModelBase?> {
  final AuthRepository authRepository;
  final UserMeRepository userMeRepository;
  final FlutterSecureStorage flutterSecureStorage;

  UserMeStateNotifier({
    required this.authRepository,
    required this.userMeRepository,
    required this.flutterSecureStorage,
  }) : super(UserModelLoading()) {
    // get me
    getMe();
  }

  Future<void> getMe() async {
    final refreshToken =
        await flutterSecureStorage.read(key: REFRESH_TOKEN_KEY);
    final accessToken = await flutterSecureStorage.read(key: ACCESS_TOKEN_KEY);

    if (refreshToken == null || accessToken == null) {
      state = null;
      return;
    }

    final resp = await userMeRepository.getMe();

    state = resp;
  }

  Future<UserModelBase> login({
    required String username,
    required String password,
  }) async {
    try {
      state = UserModelLoading();

      final resp = await authRepository.login(
        username: username,
        password: password,
      );

      await flutterSecureStorage.write(
          key: REFRESH_TOKEN_KEY, value: resp.refreshToken);
      await flutterSecureStorage.write(
          key: ACCESS_TOKEN_KEY, value: resp.accessToken);

      final userResp = await userMeRepository.getMe();

      state = userResp;
    } catch (e) {
      state = UserModelError(message: '로그인 실패');
    }
    return Future.value(state);
  }

  Future<void> logout() async {
    state = null;

    // await flutterSecureStorage.delete(key: REFRESH_TOKEN_KEY);
    // await flutterSecureStorage.delete(key: ACCESS_TOKEN_KEY);

    // 동시 실행
    await Future.wait(
      [
        flutterSecureStorage.delete(key: REFRESH_TOKEN_KEY),
        flutterSecureStorage.delete(key: ACCESS_TOKEN_KEY),
      ],
    );
  }
}
