import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_project/ui/receipt/receipt.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebView extends StatelessWidget {
  final String bankGateWayUrl;
  const PaymentWebView({Key? key, required this.bankGateWayUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: bankGateWayUrl,
      javascriptMode: JavascriptMode.unrestricted,
      onPageStarted: (url) {
        final uri = Uri.parse(url);
        if (uri.pathSegments.contains('appCheckout') &&
            uri.host == 'expertdevelopers.ir') {
          final orderId = int.parse(uri.queryParameters['order_id']!);
          Navigator.of(context).pop();
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ReceiptScreen(
                    orderId: orderId,
                  )));
        }
      },
    );
  }
}
