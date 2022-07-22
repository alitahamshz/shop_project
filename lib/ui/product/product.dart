import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_project/common/utils.dart';
import 'package:shop_project/ui/product/productDetail/productDetail.dart';

import '../../data/model/product.dart';
import '../home/widgets/cachedImage.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({
    Key? key,
    required this.product,required this.borderRadius
  }) : super(key: key);

  final ProductEntity product;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: InkWell(
        borderRadius: borderRadius,
        onTap: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProductDetailScreen(product: product))),
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
                            imageUrl: product.imageUrl,
                            borderRadius: borderRadius),
                      )),
                  Positioned(
                    right: 16,
                    top: 8,
                    child: Container(
                      width: 32,
                      height: 32,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white),
                      child: Icon(CupertinoIcons.heart),
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
                  product.title,
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
                  product.previousPrice.WithPriceLabel,
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
                child: Text(product.price.WithPriceLabel),
              ),
            ],
          ),
        ),
      ),
    );
  }
}