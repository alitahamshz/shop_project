import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shop_project/common/exeption.dart';
import 'package:shop_project/data/model/product.dart';

part 'product_list_event.dart';
part 'product_list_state.dart';

class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  ProductListBloc() : super(ProductListInitial()) {
    on<ProductListEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
