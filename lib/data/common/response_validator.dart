import 'package:dio/dio.dart';
import 'package:shop_project/common/exeption.dart';

mixin HttpResponseValidator {
    validateResult(Response response){
   if(response.statusCode != 200){
     throw AppExeption();
   }
  }
}