class ProductSort{
  static int latest = 0;
  static int popular = 1;
  static int priceHighToLow = 2;
  static int priceLowToHigh = 3;

  static const List<String> names =[
    'جدیدترین',
    'پربازدیدترین',
    'گرانترین',
    'ارزانترین'
  ];
}

class ProductEntity{
  final int id;
  final String title;
  final String imageUrl;
  final int price;
  final int previousPrice;
  final int discount;

  ProductEntity.fromJson(Map<String,dynamic> json) :
  id = json['id'],
  title = json['title'],
  imageUrl = json['image'],
  price = json['price'],
  previousPrice = json['previous_price'] ?? json['price'] + json['discount'],
  discount = json['discount'];
}