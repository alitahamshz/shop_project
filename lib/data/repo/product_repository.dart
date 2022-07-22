import 'package:shop_project/data/common/http_client.dart';
import 'package:shop_project/data/model/product.dart';
import 'package:shop_project/data/source/product_source.dart';



final productRepository = ProductRepository(ProductDataSource(httpClient));

abstract class IProductRepository {
  Future<List<ProductEntity>> getAllProducts(int sort);
  Future<List<ProductEntity>> searchProduct(String searchTerm);
}

class ProductRepository implements IProductRepository {
  final IproductDataSource dataSource;

  ProductRepository(this.dataSource);
  @override
  Future<List<ProductEntity>> getAllProducts(int sort) =>
      dataSource.getAllProducts(sort);

  @override
  Future<List<ProductEntity>> searchProduct(String searchTerm) =>
      dataSource.searchProduct(searchTerm);
}
