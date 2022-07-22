part of 'payment_receipt_bloc.dart';

abstract class PaymentReceiptState extends Equatable {
  const PaymentReceiptState();

  @override
  List<Object> get props => [];
}

class PaymentReceiptInitial extends PaymentReceiptState {}

class PaymentReceiptLoading extends PaymentReceiptState {}

class PaymentReceiptSuccess extends PaymentReceiptState {
  final PaymentReceiptData paymentReceiptData;

  const PaymentReceiptSuccess(this.paymentReceiptData);
  @override
  List<Object> get props => [paymentReceiptData];
}

class PaymentReceiptError extends PaymentReceiptState {
  final AppExeption exeption;

  const PaymentReceiptError(this.exeption);
  @override
  List<Object> get props => [exeption];
}
