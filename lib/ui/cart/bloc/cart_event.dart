part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class CartStarted extends CartEvent {
  final AuthInfo? authInfo;
  final bool isRefreshing;

  const CartStarted(this.authInfo, {this.isRefreshing=false});
}

class CartDeleteButtonClicked extends CartEvent{
  final int cartItemId;

  const CartDeleteButtonClicked(this.cartItemId);
  @override
  // TODO: implement props
  List<Object> get props => [cartItemId];

}
class CartAuthInfoChanged extends CartEvent{
  final AuthInfo? authInfo;

  const CartAuthInfoChanged(this.authInfo);
}
class PlusCountButtonClicked extends CartEvent{
  final int cartItemId;

  const PlusCountButtonClicked(this.cartItemId);
  @override

  List<Object> get props => [cartItemId];
  
}
class MinusCountButtonClicked extends CartEvent{
  final int cartItemId;

  const MinusCountButtonClicked(this.cartItemId);
  @override

  List<Object> get props => [cartItemId];
  
}
