import 'dart:ffi';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shop_project/data/model/product.dart';

final favoriteManage = FavoriteManage();

class FavoriteManage{
  static const _boxName= 'favorites';
  final _box = Hive.box<ProductEntity>(_boxName);
  ValueListenable<Box<ProductEntity>> get listenable => Hive.box<ProductEntity>(_boxName).listenable();
  static init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ProductEntityAdapter());
    Hive.openBox<ProductEntity>(_boxName);
  }
   void addFavorite(ProductEntity product){
    _box.put(product.id, product);
   }

   void deleteFavorite(ProductEntity product){
    _box.delete(product.id);
   }

   List<ProductEntity> get favorites => _box.values.toList();
   bool isFavorites (ProductEntity product){
    return _box.containsKey(product.id);
   }
}