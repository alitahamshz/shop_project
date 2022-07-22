import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shop_project/common/exeption.dart';
import 'package:shop_project/data/model/banner.dart';
import 'package:shop_project/data/model/product.dart';
import 'package:shop_project/data/repo/banner_repository.dart';
import 'package:shop_project/data/repo/product_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final IBannerRepository bannerRepository;
  final IProductRepository productRepository;
  HomeBloc({required this.bannerRepository, required this.productRepository})
      : super(HomeLoading()) {
    on<HomeEvent>((event, emit) async {
      if (event is HomeStarted || event is HomeRefresh) {
       try {
         emit(HomeLoading());
          final banners = await bannerRepository.getAllBanner();
        final latestProducts =
            await productRepository.getAllProducts(ProductSort.latest);
        final popularProducts =
            await productRepository.getAllProducts(ProductSort.popular);

            emit(HomeSuccess(banners: banners, latestProducts: latestProducts, popularProducts: popularProducts));
       } catch (e) {
         emit(HomeError(exeption: e is AppExeption? e :AppExeption()));
       }
      }
    });
  }
}
