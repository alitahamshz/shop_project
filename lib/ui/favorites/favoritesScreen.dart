import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shop_project/common/utils.dart';
import 'package:shop_project/data/model/product.dart';
import 'package:shop_project/data/source/favorite_manager.dart';
import 'package:shop_project/ui/product/productDetail/productDetail.dart';

import '../home/widgets/cachedImage.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('لیست علاقه مندی ها')),
      body: ValueListenableBuilder<Box<ProductEntity>>(
        valueListenable: favoriteManage.listenable,
        builder: (BuildContext context, value, Widget? child) {
          final products = value.values.toList();
          return ListView.builder(
              itemCount: products.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            ProductDetailScreen(product: products[index])));
                  },
                  onLongPress: (){
                    favoriteManage.deleteFavorite(products[index]);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        SizedBox(
                            width: 100,
                            height: 100,
                            child: ImageCachedService(
                              imageUrl: products[index].imageUrl,
                              borderRadius: BorderRadius.circular(8),
                            )),
                        Expanded(
                            child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(products[index].title),
                              Text(
                                products[index].previousPrice.WithPriceLabel,
                                style: Theme.of(context).textTheme.caption,
                              ),
                              Text(products[index].price.WithPriceLabel)
                            ],
                          ),
                        ))
                      ],
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}
