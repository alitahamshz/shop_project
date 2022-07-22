import 'package:dio/dio.dart';
import 'package:shop_project/common/constants.dart';
import 'package:shop_project/data/common/http_client.dart';
import 'package:shop_project/data/common/response_validator.dart';
import 'package:shop_project/data/model/auth.dart';

abstract class IAuthDataSource {
 Future<AuthInfo> login(String username,String password);
 Future<AuthInfo> register(String username,String password);
 Future<AuthInfo> refreshToken(String token);
}

class AuthDataSource with HttpResponseValidator implements IAuthDataSource{
  final Dio httpClient;
  AuthDataSource(this.httpClient);
  @override
  Future<AuthInfo> login(String username, String password) async {
   final result = await httpClient.post('auth/token',data : {
    "grant_type" : "password",
    "client_id" : 2,
    "client_secret":Constants.clientSecret,
    "username":username,
    "password" : password
   });
   validateResult(result);
   return AuthInfo(result.data["access_token"], result.data["refresh_token"]);
  }

  @override
  Future<AuthInfo> refreshToken(String token) async {
   final result = await httpClient.post('auth/token',data:{
     "grant_type" : "password",
    "refresh_token" : token,
     "client_id" : 2,
    "client_secret":Constants.clientSecret,
   });
   validateResult(result);
   return AuthInfo(result.data["access_token"], result.data['refresh_token']);
  }

  @override
  Future<AuthInfo> register(String username, String password)async {
    final result = await httpClient.post('user/register',data:{
      "email":username,
      "password":password
    });
    validateResult(result);
    return login(username, password);
  }

}