import 'package:dio/dio.dart';
import 'package:shop_project/common/exeption.dart';
import 'package:shop_project/data/common/response_validator.dart';
import '../model/product.dart';

abstract class IproductDataSource{
Future<List<ProductEntity>> getAllProducts(int sort);
  Future<List<ProductEntity>> searchProduct(String searchTerm);
}

class ProductDataSource with HttpResponseValidator implements IproductDataSource{
  final Dio httpClient;

  ProductDataSource(this.httpClient);

  @override
  Future<List<ProductEntity>> getAllProducts(int sort) async {
    final result = await httpClient.get('product/list?sort=$sort');
    // validateResult(result);
    final products = <ProductEntity>[];
    (result.data as List).forEach((element) {
      products.add(ProductEntity.fromJson(element));
    });
    return products;
  }

  @override
  Future<List<ProductEntity>> searchProduct(String searchTerm) async{
    final result = await httpClient.get('product/search?q=$searchTerm');
    validateResult(result);
    final products = <ProductEntity>[];
    (result.data as List).forEach((element) {
      products.add(ProductEntity.fromJson(element));
    });
    return products;
  }
}