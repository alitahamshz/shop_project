import 'package:hive_flutter/adapters.dart';
part 'product.g.dart';
class ProductSort {
  static int latest = 0;
  static int popular = 1;
  static int priceHighToLow = 2;
  static int priceLowToHigh = 3;

  static const List<String> names = [
    'جدیدترین',
    'پربازدیدترین',
    'گرانترین',
    'ارزانترین'
  ];
}

@HiveType(typeId: 0)
class ProductEntity {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String imageUrl;
  @HiveField(3)
  final int price;
  @HiveField(4)
  final int previousPrice;
  @HiveField(5)
  final int discount;
  ProductEntity(this.id,this.title,this.imageUrl,this.price,this.previousPrice,this.discount);
  ProductEntity.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        imageUrl = json['image'],
        price = json['price'],
        previousPrice =
            json['previous_price'] ?? json['price'] + json['discount'],
        discount = json['discount'];
}
