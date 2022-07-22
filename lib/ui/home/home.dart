import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_project/common/exeption.dart';
import 'package:shop_project/common/utils.dart';
import 'package:shop_project/data/model/banner.dart';
import 'package:shop_project/data/model/product.dart';
import 'package:shop_project/data/repo/banner_repository.dart';
import 'package:shop_project/data/repo/product_repository.dart';
import 'package:shop_project/ui/home/bloc/home_bloc.dart';
import 'package:shop_project/ui/home/widgets/cachedImage.dart';
import 'package:shop_project/ui/home/widgets/error.dart';
import 'package:shop_project/ui/product/product.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final homeBloc = HomeBloc(
            bannerRepository: bannerRepository,
            productRepository: productRepository);
        homeBloc.add(HomeStarted());
        return homeBloc;
      },
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<HomeBloc, HomeState>(builder: ((context, state) {
            if (state is HomeSuccess) {
              return ListView.builder(
                  itemCount: 6,
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 100),
                  itemBuilder: (context, index) {
                    switch (index) {
                      case 0:
                        return Column(
                          children: [
                            Image.asset(
                              'assets/img/nike_logo.png',
                              height: 22,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        );

                      case 2:
                        return bannerSlider(
                          banners: state.banners,
                        );

                      case 3:
                        return _HorizontalProductList(
                          onTap: () {},
                          title: 'جدیدترین ها',
                          products: state.latestProducts,
                        );
                      case 4:
                        return const SizedBox(
                          height: 20,
                        );
                      case 5:
                        return _HorizontalProductList(
                          onTap: () {},
                          title: 'پربازدیدترین ها',
                          products: state.latestProducts,
                        );
                      default:
                        return Container();
                    }
                  });
            } else if (state is HomeLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is HomeError) {
              return AppErrorWidget(exeption:state.exeption,onPressed: (){
                BlocProvider.of<HomeBloc>(context).add(HomeRefresh());
              },);
            } else {
              throw Exception('state is not supported');
            }
          })),
        ),
      ),
    );
  }
}



class _HorizontalProductList extends StatelessWidget {
  final String title;
  final GestureTapCallback onTap;
  final List<ProductEntity> products;
  const _HorizontalProductList(
      {Key? key,
      required this.title,
      required this.onTap,
      required this.products})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: Theme.of(context).textTheme.subtitle1),
            TextButton(onPressed: onTap, child: Text('مشاهده همه'))
          ],
        ),
        SizedBox(
          height: 290,
          child: ListView.builder(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              itemBuilder: ((context, index) {
                final product = products[index];
                return ProductItem(product: product,borderRadius: BorderRadius.circular(12));
              })),
        )
      ],
    );
  }
}



class bannerSlider extends StatelessWidget {
  final PageController _controller = PageController();
  final List<BannerEntity> banners;
  bannerSlider({Key? key, required this.banners}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: Stack(children: [
        PageView.builder(
            controller: _controller,
            itemCount: banners.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) => _Slide(banner: banners[index])),
        Positioned(
          bottom: 6,
          left: 0,
          right: 0,
          child: Center(
            child: SmoothPageIndicator(
                controller: _controller,
                count: banners.length,
                axisDirection: Axis.horizontal,
                effect: WormEffect(
                  dotColor: Colors.grey.shade400,
                  // activeStrokeWidth: 2.6,
                  // activeDotScale: 1.3,
                  activeDotColor: Theme.of(context).colorScheme.onBackground,
                  // maxVisibleDots: 5,
                  radius: 8,
                  spacing: 10,
                  dotHeight: 3,
                  dotWidth: 15,
                )),
          ),
        ),
      ]),
    );
  }
}

class _Slide extends StatelessWidget {
  final BannerEntity banner;
  const _Slide({
    Key? key,
    required this.banner,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ImageCachedService(
      imageUrl: banner.imageUrl,
      borderRadius: BorderRadius.circular(20),
    );
  }
}
