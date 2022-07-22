part of 'cart_bloc.dart';

abstract class CartState {
  const CartState();

}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartSuccess extends CartState {
  final CartResponse cartResponse;

  const CartSuccess(this.cartResponse);
}

class CartError extends CartState {
  final AppExeption exeption;

  const CartError(this.exeption);
}
class AuthRequired extends CartState{}
class CartEmpty extends CartState{}
