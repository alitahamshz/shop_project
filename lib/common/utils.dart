import 'package:intl/intl.dart';



extension PriceLabel on int{
  String get WithPriceLabel =>this > 0 ? '$seprateByComma تومان': 'رایگان';

  String get seprateByComma {
    final numberFormat = NumberFormat.decimalPattern();

    return numberFormat.format(this);
}
}