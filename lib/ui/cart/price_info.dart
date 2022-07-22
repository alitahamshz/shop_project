import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_project/common/utils.dart';

class PriceInfo extends StatelessWidget {
  final int payablePrice;
  final int shippingCost;
  final int totalPrice;
  const PriceInfo(
      {Key? key,
      required this.payablePrice,
      required this.shippingCost,
      required this.totalPrice})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
          child: Text(
            'جزییات خرید',
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(8, 16, 8, 32),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(2),
              boxShadow: [
                BoxShadow(blurRadius: 10, color: Colors.black.withOpacity(0.1))
              ]),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('مبلغ کل خرید'),
                    Text(totalPrice.WithPriceLabel)
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('هزینه ارسال'),
                    Text(shippingCost.WithPriceLabel)
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('مبلغ قابل پرداخت'),
                    // Text(payablePrice.WithPriceLabel)
                    RichText(
                      text: TextSpan(
                          text: payablePrice.seprateByComma,
                          style: DefaultTextStyle.of(context).style.copyWith(
                              fontWeight: FontWeight.bold, fontSize: 17),
                          children: const [
                            TextSpan(
                                text: ' تومان',
                                style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.normal)),
                          ]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
