import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_project/common/utils.dart';
import 'package:shop_project/data/source/favorite_manager.dart';
import 'package:shop_project/ui/product/productDetail/productDetail.dart';

import '../../data/model/product.dart';
import '../home/widgets/cachedImage.dart';

class ProductItem extends StatefulWidget {
  const ProductItem({
    Key? key,
    required this.product,required this.borderRadius
  }) : super(key: key);

  final ProductEntity product;
  final BorderRadius borderRadius;

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: InkWell(
        borderRadius: widget.borderRadius,
        onTap: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProductDetailScreen(product: widget.product))),
        child: SizedBox(
          width: 176,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  SizedBox(
                      height: 189,
                      width: 176,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8,right: 8),
                        child: ImageCachedService(
                            imageUrl: widget.product.imageUrl,
                            borderRadius: widget.borderRadius),
                      )),
                  Positioned(
                    right: 16,
                    top: 8,
                    child: InkWell(
                      onTap: (){
                        if(!favoriteManage.isFavorites(widget.product)){
                          favoriteManage.addFavorite(widget.product);
                        }else{
                          favoriteManage.deleteFavorite(widget.product);
                        }
                        setState((){});
                      },
                      child: Container(
                        width: 32,
                        height: 32,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white),
                        child: Icon(favoriteManage.isFavorites(widget.product)? CupertinoIcons.heart_fill: CupertinoIcons.heart),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12, left: 4),
                child: Text(
                  widget.product.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12, left: 4),
                child: Text(
                  widget.product.previousPrice.WithPriceLabel,
                  style: Theme.of(context)
                      .textTheme
                      .caption!
                      .copyWith(
                          decoration: TextDecoration.lineThrough),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12, left: 4),
                child: Text(widget.product.price.WithPriceLabel),
              ),
            ],
          ),
        ),
      ),
    );
  }
}