import 'package:code_factory_app/common/const/data.dart';
import 'package:code_factory_app/user/model/user_model.dart';
import 'package:code_factory_app/user/repository/user_me_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserMeStateNotifier extends StateNotifier<UserModelBase?>{
  final UserMeRepository userMeRepository;
  final FlutterSecureStorage flutterSecureStorage;

  UserMeStateNotifier({
    required this.userMeRepository,
    required this.flutterSecureStorage,
}) : super(UserModelLoading()){
    // get me
    getMe();
  }

  Future<void> getMe() async{
    final refreshToken = await flutterSecureStorage.read(key: REFRESH_TOKEN_KEY);
    final accessToken = await flutterSecureStorage.read(key: ACCESS_TOKEN_KEY);

    if(refreshToken == null || accessToken == null){
      return;
    }

   final resp = await userMeRepository.getMe();

    state = resp;
  }
}