part of 'product_list_bloc.dart';

abstract class ProductListState extends Equatable {
  const ProductListState();

  @override
  List<Object> get props => [];
}

class ProductListInitial extends ProductListState {}

class ProductListLoading extends ProductListState {}

class ProductListSuccess extends ProductListState {
  final List<ProductEntity> products;
  final int sort;
  final List<String> sortNames;
  const ProductListSuccess(this.products, this.sort, this.sortNames);

}

class ProductListError extends ProductListState {
  final AppExeption exeption;

  const ProductListError(this.exeption);
@override
  // TODO: implement props
  List<Object> get props => [exeption];
}
