import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_project/common/utils.dart';
import 'package:shop_project/data/repo/order_repository.dart';
import 'package:shop_project/theme/theme.dart';
import 'package:shop_project/ui/receipt/bloc/payment_receipt_bloc.dart';

class ReceiptScreen extends StatelessWidget {
  final int orderId;
const ReceiptScreen({Key? key, required this.orderId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('movieTitle: $orderId');  

    return Scaffold(
      appBar: AppBar(title: Text('رسید پرداخت')),
      body: BlocProvider<PaymentReceiptBloc>(
        create: (context) => PaymentReceiptBloc(orderRepository)..add(PaymentReceiptStarted(orderId)),
        child: BlocBuilder<PaymentReceiptBloc, PaymentReceiptState>(
          builder: (context, state) {
            if (state is PaymentReceiptSuccess) {
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(8)),
                      child: Column(
                        children: [
                          Text(state.paymentReceiptData.purchaseSuccess?'پرداخت موفق':'پرداخت ناموفق',
                              style: TextStyle(color:state.paymentReceiptData.purchaseSuccess? Colors.green :Colors.red)),
                         const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'وضعیت سفارش',
                                style: TextStyle(
                                    color: LightThemeColor.secondaryTextColor),
                              ),
                              Text(state.paymentReceiptData.paymentStatus,
                                  style:const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13))
                            ],
                          ),
                          const Divider(
                            height: 30,
                            thickness: 1,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children:  [
                              const Text(
                                'مبلع',
                                style:  TextStyle(
                                    color: LightThemeColor.secondaryTextColor),
                              ),
                              Text(state.paymentReceiptData.payablePrice.WithPriceLabel,
                                  style:const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13))
                            ],
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                        },
                        child: Text("بازگشت به صفحه اصلی"))
                    //  Text("پرداخت با موفقیت انجام شد"),
                  ]);
            } else if (state is PaymentReceiptError) {
              return Center(child: Text(state.exeption.message));
            } else if (state is PaymentReceiptLoading) {
              return Center(child: CupertinoActivityIndicator());
            } else {
              return Center(child: Text('خطای نامشخص'),);
            }
          },
        ),
      ),
    );
  }
}
