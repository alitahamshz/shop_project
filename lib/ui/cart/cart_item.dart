import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_project/common/utils.dart';

import '../../data/model/cart_item.dart';
import '../home/widgets/cachedImage.dart';

class CartItem extends StatelessWidget {
  const CartItem({
    Key? key,
    required this.data,
    required this.onDeleteButtonClick,
    required this.onPlusButtonClick,
    required this.onMinusButtonClick,
  }) : super(key: key);

  final CartItemEntity data;
  final GestureTapCallback onDeleteButtonClick;
  final GestureTapCallback onPlusButtonClick;
  final GestureTapCallback onMinusButtonClick;

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: MediaQuery.of(context).size.width,

      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
        ],
      ),
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              SizedBox(
                  width: 100,
                  height: 100,
                  child: ImageCachedService(
                    imageUrl: data.product.imageUrl,
                    borderRadius: BorderRadius.circular(5),
                  )),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(data.product.title),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('تعداد'),
                  Row(
                    children: [
                      IconButton(
                          onPressed: onPlusButtonClick,
                          icon: const Icon(CupertinoIcons.plus_rectangle)),
                      data.changeCountLoading == true
                          ? const CupertinoActivityIndicator()
                          : Text(data.count.toString()),
                      IconButton(
                          onPressed: onMinusButtonClick,
                          icon: const Icon(CupertinoIcons.minus_rectangle)),
                    ],
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    data.product.previousPrice.WithPriceLabel,
                    style: Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(decoration: TextDecoration.lineThrough),
                  ),
                  Text(data.product.price.WithPriceLabel),
                ],
              )
            ],
          ),
        ),
        const Divider(
          height: 1,
        ),
        data.deleteButtonLoading
            ? const Center(
                child: CupertinoActivityIndicator(),
              )
            : TextButton(
                onPressed: onDeleteButtonClick,
                child: Text(
                  'حذف',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.onSurface),
                ),
              )
      ]),
    );
  }
}
