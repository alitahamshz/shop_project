import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_project/data/model/order.dart';
import 'package:shop_project/data/repo/order_repository.dart';
import 'package:shop_project/ui/cart/price_info.dart';
import 'package:shop_project/ui/payment/paymentWebView.dart';
import 'package:shop_project/ui/receipt/bloc/payment_receipt_bloc.dart';
import 'package:shop_project/ui/receipt/receipt.dart';
import 'package:shop_project/ui/shipping/bloc/shipping_bloc.dart';

class ShippingScreen extends StatefulWidget {
  final int payablePrice;
  final int shippingCost;
  final int totalPrice;

  const ShippingScreen(
      {Key? key,
      required this.payablePrice,
      required this.shippingCost,
      required this.totalPrice})
      : super(key: key);

  @override
  State<ShippingScreen> createState() => _ShippingScreenState();
}

class _ShippingScreenState extends State<ShippingScreen> {
  final TextEditingController firstNameController =
      TextEditingController(text: 'علی');

  final TextEditingController lastNameController =
      TextEditingController(text: 'رزمجو');

  final TextEditingController mobileController =
      TextEditingController(text: '09900387616');

  final TextEditingController postalCodeController =
      TextEditingController(text: '7167688431');

  final TextEditingController addressController =
      TextEditingController(text: 'شیراز خیابان قائم کوچه 68 پلاک 76');

  StreamSubscription? subscription;

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تحویل گیرنده'),
      ),
      body: BlocProvider<ShippingBloc>(
        create: (context) {
          final bloc = ShippingBloc(orderRepository);
          subscription = bloc.stream.listen((event) {
            if (event is ShippingError) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(event.appExeption.message)));
            } else if (event is ShippingSuccess) {
              if (event.result.bankGatewayUrl.isNotEmpty) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PaymentWebView(
                          bankGateWayUrl: event.result.bankGatewayUrl,
                        )));
              } else {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        ReceiptScreen(orderId: event.result.orderId)));
              }
            }
          });
          return bloc;
        },
        child: SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(
                    controller: firstNameController,
                    decoration: InputDecoration(label: Text('نام'))),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                    controller: lastNameController,
                    decoration: InputDecoration(label: Text('نام خانوادگی'))),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                    controller: mobileController,
                    decoration: InputDecoration(label: Text('شماره تماس'))),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                    controller: postalCodeController,
                    decoration: InputDecoration(label: Text('کد پستی'))),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                    controller: addressController,
                    decoration:
                        InputDecoration(label: Text('آدرس تحویل گیرنده'))),
                const SizedBox(
                  height: 10,
                ),
                PriceInfo(
                    payablePrice: widget.payablePrice,
                    shippingCost: widget.shippingCost,
                    totalPrice: widget.totalPrice),
                BlocBuilder<ShippingBloc, ShippingState>(
                  builder: (context, state) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              BlocProvider.of<ShippingBloc>(context).add(
                                  ShippingCreateOrder(CreateOrderParams(
                                      firstNameController.text,
                                      lastNameController.text,
                                      mobileController.text,
                                      postalCodeController.text,
                                      addressController.text,
                                      PaymentMethod.online)));
                            },
                            child: const Text('پرداخت اینترنتی')),
                        OutlinedButton(
                            onPressed: () {
                              BlocProvider.of<ShippingBloc>(context).add(
                                  ShippingCreateOrder(CreateOrderParams(
                                      firstNameController.text,
                                      lastNameController.text,
                                      mobileController.text,
                                      postalCodeController.text,
                                      addressController.text,
                                      PaymentMethod.cashOnDelivery)));
                            },
                            child: const Text('پرداخت در محل'))
                      ],
                    );
                  },
                )
              ],
            )),
      ),
    );
  }
}
