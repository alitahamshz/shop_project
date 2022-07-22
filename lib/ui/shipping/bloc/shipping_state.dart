part of 'shipping_bloc.dart';

abstract class ShippingState extends Equatable {
  const ShippingState();
  
  @override
  List<Object> get props => [];
}

class ShippingInitial extends ShippingState {}
class ShippingLoading extends ShippingState {}
class ShippingError extends ShippingState {
  final AppExeption appExeption;

  const ShippingError(this.appExeption);
  @override
  // TODO: implement props
  List<Object> get props => [appExeption];
}
class ShippingSuccess extends ShippingState {
  final CreateOrderResult result;

 const ShippingSuccess(this.result);
 @override
  // TODO: implement props
  List<Object> get props => [result];
}
