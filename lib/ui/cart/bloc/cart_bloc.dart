import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:shop_project/common/exeption.dart';
import 'package:shop_project/data/model/cart_response.dart';
import 'package:shop_project/data/repo/cart_repository.dart';

import '../../../data/model/auth.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final ICartRepository cartRepository;
  CartBloc(this.cartRepository) : super(CartLoading()) {
    on<CartEvent>((event, emit) async {
      if (event is CartStarted) {
        final authInfo = event.authInfo;
        if (authInfo == null || authInfo.accessToken.isEmpty) {
          emit(AuthRequired());
        } else {
          try {
            if (!event.isRefreshing) {
              emit(CartLoading());
            }
            final result = await cartRepository.getAll();
            if (result.cartItems.isEmpty) {
              emit(CartEmpty());
            } else {
              emit(CartSuccess(result));
            }
          } catch (e) {
            emit(CartError(AppExeption()));
          }
        }
      } else if (event is CartAuthInfoChanged) {
        if (event.authInfo == null || event.authInfo!.accessToken.isEmpty) {
          emit(AuthRequired());
        } else {
          if (state is AuthRequired) {
            try {
              emit(CartLoading());
              final result = await cartRepository.getAll();
              emit(CartSuccess(result));
            } catch (e) {
              emit(CartError(AppExeption()));
            }
          }
        }
      } else if (event is CartDeleteButtonClicked) {
        try {
          if (state is CartSuccess) {
            final successState = (state as CartSuccess);
            //  final cartItem = successState.cartResponse.cartItems.firstWhere((element) => element.id == event.cartItemId);
            final index = successState.cartResponse.cartItems
                .indexWhere((element) => element.id == event.cartItemId);
            //  cartItem.deleteButtonLoading = true;
            successState.cartResponse.cartItems[index].deleteButtonLoading =
                true;
            emit(CartSuccess(successState.cartResponse));
          }
          await cartRepository.delete(event.cartItemId);
          await cartRepository.count();
          if (state is CartSuccess) {
            final successState = (state as CartSuccess);
            successState.cartResponse.cartItems
                .removeWhere((element) => element.id == event.cartItemId);
            if (successState.cartResponse.cartItems.isEmpty) {
              emit(CartEmpty());
            } else {
              emit(calculatePriceInfo(successState.cartResponse));
            }
          }
        } catch (e) {
          debugPrint(e.toString());
        }
      } else if (event is PlusCountButtonClicked) {
        try {
          if (state is CartSuccess) {
            final successState = (state as CartSuccess);
            //  final cartItem = successState.cartResponse.cartItems.firstWhere((element) => element.id == event.cartItemId);
            final index = successState.cartResponse.cartItems
                .indexWhere((element) => element.id == event.cartItemId);
            //  cartItem.deleteButtonLoading = true;
            successState.cartResponse.cartItems[index].changeCountLoading =
                true;
            emit(CartSuccess(successState.cartResponse));
            final changeCount =
                successState.cartResponse.cartItems[index].count + 1;
           
              await cartRepository.changeCount(event.cartItemId, changeCount);
              await cartRepository.count();
              successState.cartResponse.cartItems
                  .firstWhere((element) => element.id == event.cartItemId)
                ..count = changeCount
                ..changeCountLoading = false;

              emit(calculatePriceInfo(successState.cartResponse));
         
          }
        } catch (e) {
          debugPrint(e.toString());
        }
      } else if (event is MinusCountButtonClicked) {
        try {
          if (state is CartSuccess) {
            final successState = (state as CartSuccess);
            //  final cartItem = successState.cartResponse.cartItems.firstWhere((element) => element.id == event.cartItemId);
            final index = successState.cartResponse.cartItems
                .indexWhere((element) => element.id == event.cartItemId);
            //  cartItem.deleteButtonLoading = true;
            successState.cartResponse.cartItems[index].changeCountLoading =
                true;
            emit(CartSuccess(successState.cartResponse));
            final changeCount =
                successState.cartResponse.cartItems[index].count - 1;
           
              await cartRepository.changeCount(event.cartItemId, changeCount);
              await cartRepository.count();
              successState.cartResponse.cartItems
                  .firstWhere((element) => element.id == event.cartItemId)
                ..count = changeCount
                ..changeCountLoading = false;

              emit(calculatePriceInfo(successState.cartResponse));
            
          }
        } catch (e) {
          debugPrint(e.toString());
        }
      }
    });
  }

  CartSuccess calculatePriceInfo(CartResponse cartResponse) {
    int totalPrice = 0;
    int payablePrice = 0;
    int shippingCost = 0;

    cartResponse.cartItems.forEach((cartItem) {
      totalPrice += cartItem.product.previousPrice * cartItem.count;
      payablePrice += cartItem.product.price * cartItem.count;
    });
    shippingCost = payablePrice > 250000 ? 0 : 30000;
    cartResponse.totalPrice = totalPrice;
    cartResponse.payablePrice = payablePrice;
    cartResponse.shippingCost = shippingCost;
    return CartSuccess(cartResponse);
  }
}
