import 'package:dio/dio.dart';
import 'package:shop_project/data/model/cart_item.dart';
import 'package:shop_project/data/model/add_to_cart_response.dart';
import 'package:shop_project/data/model/cart_response.dart';
import 'package:shop_project/data/repo/cart_repository.dart';

abstract class ICartDataSource {
  Future<AddToCartResponse> add(int productId);
  Future<AddToCartResponse> changeCount(int cartItemId, int count);
  Future<void> delete(int cartItemId);
  Future<int> count();
  Future<CartResponse> getAll();
}

class cartDataSource implements ICartDataSource {
  final Dio httpClient;

  cartDataSource(this.httpClient);

  @override
  Future<AddToCartResponse> add(int productId) async {
    final result =
        await httpClient.post('cart/add', data: {"product_id": productId});

    return AddToCartResponse.fromJson(result.data);
  }

  @override
  Future<AddToCartResponse> changeCount(int cartItemId, int count) async {
    final result = await httpClient.post('cart/changeCount',data:{
      "cart_item_id":cartItemId,
      "count":count
    });
    return AddToCartResponse.fromJson(result.data);
  }

  @override
  Future<int> count() async {
    final response = await httpClient.get('cart/count');
    return response.data['count'];

  }

  @override
  Future<void> delete(int cartItemId) async {
     await httpClient.post('cart/remove',data:{
      "cart_item_id" : cartItemId
    });
  }

  @override
  Future<CartResponse> getAll()async {
    final result = await httpClient.get('cart/list');
    return CartResponse.fromJson(result.data);
  }
}
