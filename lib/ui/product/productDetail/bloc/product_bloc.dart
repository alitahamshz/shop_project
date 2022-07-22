import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shop_project/common/exeption.dart';
import 'package:shop_project/data/repo/cart_repository.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ICartRepository cartRepository;
  ProductBloc(this.cartRepository) : super(ProductInitial()) {
    on<ProductEvent>((event, emit) async {
      if (event is CartAddButtonClick) {
        try {
           emit(ProductAddToCartButtonLoading());
          final result = await cartRepository.add(event.productId);
          await cartRepository.count();
          emit(ProductAddToCartButtonSuccess());
        } catch (e) {
          emit(ProductAddToCartButtonError(AppExeption()));
        }
         
        
      }
    });
  }
}
