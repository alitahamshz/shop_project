import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_project/data/common/http_client.dart';
import 'package:shop_project/data/model/auth.dart';
import 'package:shop_project/data/source/auth_source.dart';

final authRepository = AuthRepository(AuthDataSource(httpClient));

abstract class IAuthRepository {
  Future<void> login(String username, String password);
  Future<void> refresh();
  Future<void> register(String username, String password);
  Future<void> signOut();
}

class AuthRepository implements IAuthRepository {
  static ValueNotifier<AuthInfo?> authChangeNotifier = ValueNotifier(null);
  final IAuthDataSource dataSource;

  AuthRepository(this.dataSource);
  @override
  Future<void> login(String username, String password) async {
    final AuthInfo authInfo = await dataSource.login(username, password);

    _persistAuthTokens(authInfo);
  }

  @override
  Future<void> register(String username, String password) async {
    final AuthInfo authInfo = await dataSource.register(username, password);
    _persistAuthTokens(authInfo);
  }

  @override
  Future<void> refresh() async {
    final AuthInfo authInfo = await dataSource.refreshToken("435gfghgjh");
    _persistAuthTokens(authInfo);
  }

  Future<void> _persistAuthTokens(AuthInfo authInfo) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setString('access_token', authInfo.accessToken);
    sharedPreferences.setString('refresh_token', authInfo.refreshToken);
    LoadAuthInfo();
  }

  Future<void> LoadAuthInfo() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final String accessToken =
        sharedPreferences.getString('access_token') ?? '';
    final String refreshToken =
        sharedPreferences.getString('refresh_token') ?? '';
    if (accessToken.isNotEmpty && refreshToken.isNotEmpty) {
      authChangeNotifier.value = AuthInfo(accessToken, refreshToken);
    }
  }

  @override
  Future<void> signOut()async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
        sharedPreferences.clear();
        authChangeNotifier.value = null;
  }
}
