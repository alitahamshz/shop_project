import 'package:shop_project/data/common/http_client.dart';
import 'package:shop_project/data/model/order.dart';
import 'package:shop_project/data/model/payment_recipt.dart';
import 'package:shop_project/data/source/order_data_source.dart';

final orderRepository = OrderRepository(OrderDataSource(httpClient));

abstract class IOrderRepository extends IOrderDataSource {}
class OrderRepository implements IOrderRepository{
 final IOrderDataSource dataSource;

  OrderRepository(this.dataSource);

  @override
  Future<CreateOrderResult> create(CreateOrderParams params) {
   return dataSource.create(params);
  }

  @override
  Future<PaymentReceiptData> getPaymentReceipt(int orderId) {
   return dataSource.getPaymentReceipt(orderId);
  }
}