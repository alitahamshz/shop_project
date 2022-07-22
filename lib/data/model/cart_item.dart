import 'dart:convert';

import 'package:shop_project/data/model/product.dart';

class CartItemEntity {
  final ProductEntity product;
  final int id;
  int count;
  bool deleteButtonLoading = false;
  bool changeCountLoading = false;

  CartItemEntity(this.product, this.id, this.count, this.deleteButtonLoading);

  CartItemEntity.fromJson(Map<String, dynamic> json)
      : product = ProductEntity.fromJson(json['product']),
        id = json['cart_item_id'],
        count = json['count'];

  static List<CartItemEntity> parseJsonArray(List<dynamic> jsonArray) {
    final List<CartItemEntity> cartItems = [];
    jsonArray.forEach((element) {
      cartItems.add(CartItemEntity.fromJson(element));
    });
    return cartItems;
  }
}
