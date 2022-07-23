import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shop_project/common/exeption.dart';
import 'package:shop_project/data/model/product.dart';
import 'package:shop_project/data/repo/product_repository.dart';

part 'product_list_event.dart';
part 'product_list_state.dart';

class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  final IProductRepository repository;
  ProductListBloc(this.repository) : super(ProductListInitial()) {
    on<ProductListEvent>((event, emit)async {
     if(event is ProductListStarted){
      emit(ProductListLoading());
      try {
        final products = await repository.getAllProducts(event.sort);
        emit(ProductListSuccess(products, event.sort, ProductSort.names));
      } catch (e) {
        emit(ProductListError(AppExeption()));
      }
     }
    });
  }
}
