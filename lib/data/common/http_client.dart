import 'package:dio/dio.dart';
import 'package:shop_project/data/model/auth.dart';
import 'package:shop_project/data/repo/auth_repository.dart';

final httpClient =
    Dio(BaseOptions(baseUrl: 'http://expertdevelopers.ir/api/v1/'))
      ..interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) {
          final authInfo = AuthRepository.authChangeNotifier.value;
          if (authInfo != null && authInfo.accessToken.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer ${authInfo.accessToken}';
          }
          handler.next(options);
        },
      ));
