import 'package:dio/dio.dart';
import 'package:shop_project/data/model/order.dart';
import 'package:shop_project/data/model/payment_recipt.dart';

abstract class IOrderDataSource {
  Future<CreateOrderResult> create(CreateOrderParams params);
  Future<PaymentReceiptData> getPaymentReceipt(int orderId);
}

class OrderDataSource implements IOrderDataSource{
  final Dio httpClient;

  OrderDataSource(this.httpClient);

  @override
  Future<CreateOrderResult> create(CreateOrderParams params) async{
    final result = await httpClient.post('order/submit',data:{
      'first_name': params.firstName,
      'last_name' : params.lastName,
      'mobile' : params.phoneNumber,
      'postal_code' : params.postalCode,
      'address' : params.address,
      'payment_method':params.paymentMethod == PaymentMethod.online ? 'online' : 'cash_on_delivery'
    });

return CreateOrderResult.fromJson(result.data);
  }

  @override
  Future<PaymentReceiptData> getPaymentReceipt(int orderId) async {
    final result = await httpClient.get('order/checkout?order_id=$orderId');

    return PaymentReceiptData.fromJson(result.data);
  }
}