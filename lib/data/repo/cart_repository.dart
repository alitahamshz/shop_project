import 'package:flutter/cupertino.dart';
import 'package:shop_project/data/model/cart_item.dart';
import 'package:shop_project/data/model/add_to_cart_response.dart';
import 'package:shop_project/data/model/cart_response.dart';
import 'package:shop_project/data/source/cart_source.dart';

import '../common/http_client.dart';

final cartRepository = CartRepository(cartDataSource(httpClient));

abstract class ICartRepository {
  Future<AddToCartResponse> add(int productId);
  Future<AddToCartResponse> changeCount(int cartItemId, int count);
  Future<void> delete(int cartItemId);
  Future<int> count();
  Future<CartResponse> getAll();
}

 class CartRepository implements ICartRepository {
  final ICartDataSource dataSource;
  ValueNotifier<int> cartItemCountNotifier = ValueNotifier(0);

  CartRepository(this.dataSource);
  @override
  Future<AddToCartResponse> add(int productId) => dataSource.add(productId);

  @override
  Future<AddToCartResponse> changeCount(int cartItemId, int count) {
   return dataSource.changeCount(cartItemId, count);
  }

  @override
   Future<int> count() async {
    final count = await dataSource.count();
    cartItemCountNotifier.value = count;
    return count;
  }

  @override
  Future<void> delete(int cartItemId) {
    return dataSource.delete(cartItemId);
  }

  @override
  Future<CartResponse> getAll() => dataSource.getAll();
}
