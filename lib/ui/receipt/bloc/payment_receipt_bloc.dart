import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:shop_project/common/exeption.dart';
import 'package:shop_project/data/model/payment_recipt.dart';
import 'package:shop_project/data/repo/order_repository.dart';

part 'payment_receipt_event.dart';
part 'payment_receipt_state.dart';

class PaymentReceiptBloc extends Bloc<PaymentReceiptEvent, PaymentReceiptState> {
  final IOrderRepository repository;
  PaymentReceiptBloc(this.repository) : super(PaymentReceiptInitial()) {
    on<PaymentReceiptEvent>((event, emit) async {
      if(event is PaymentReceiptStarted){
       try {
          emit(PaymentReceiptLoading());
        final result = await repository.getPaymentReceipt(event.orderId);
        emit(PaymentReceiptSuccess(result));
       } catch (e) {
        emit(PaymentReceiptError(AppExeption()));
       }
      }
      
    });
  }
}
