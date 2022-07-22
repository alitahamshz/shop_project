import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_project/common/utils.dart';
import 'package:shop_project/data/model/product.dart';
import 'package:shop_project/theme/theme.dart';
import 'package:shop_project/ui/home/widgets/cachedImage.dart';
import 'package:shop_project/ui/product/comment/commentList.dart';
import 'package:shop_project/ui/product/productDetail/bloc/product_bloc.dart';

import '../../../data/repo/cart_repository.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductEntity product;
  const ProductDetailScreen({Key? key, required this.product})
      : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  StreamSubscription<ProductState>? stateSubscription = null;

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey(); 
  @override
  void dispose() {
    stateSubscription?.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocProvider<ProductBloc>(
        create: (context) {
          final bloc = ProductBloc(cartRepository);
          stateSubscription = bloc.stream.listen((event) {
            if(event is ProductAddToCartButtonSuccess){
              _scaffoldKey.currentState?.showSnackBar((const SnackBar(duration: Duration(seconds: 3),content: Text('محصول به سبد خرید افزوده شد'),)));
            }else if(event is ProductAddToCartButtonError){
              _scaffoldKey.currentState?.showSnackBar(const SnackBar(content: Text('خطا در افزودن محصول به سبد')));
            }
          });
          return bloc;
        },
        child: ScaffoldMessenger(
          key: _scaffoldKey,
          child: Scaffold(
            floatingActionButton: SizedBox(
                width: MediaQuery.of(context).size.width - 50,
                child: BlocBuilder<ProductBloc,ProductState>(
                  builder: (context,state)=> FloatingActionButton.extended(
                      onPressed: () {
                        BlocProvider.of<ProductBloc>(context).add(CartAddButtonClick(widget.product.id));
                      }, label: state is ProductAddToCartButtonLoading? const  CupertinoActivityIndicator(
                        color: Colors.white,
                      ) : const Text('افزودن به سبد خرید')),
                )),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            body: CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  foregroundColor: LightThemeColor.primaryTextColor,
                  expandedHeight: MediaQuery.of(context).size.width * 0.8,
                  flexibleSpace: ImageCachedService(
                      imageUrl: widget.product.imageUrl,
                      borderRadius: BorderRadius.circular(0)),
                  actions: [
                    IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.heart))
                  ],
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(children: [
                      Row(
                        //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //  crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: Text(
                            widget.product.title,
                            style: Theme.of(context).textTheme.headline6,
                          )),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                widget.product.previousPrice.WithPriceLabel,
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .apply(decoration: TextDecoration.lineThrough),
                              ),
                              Text(widget.product.price.WithPriceLabel),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      const Text(
                        'کفش فوتسال سالنی تن‌زیب – کد TID9604 خطوط مورب و نقاطی که در طرح زیره کفش به کار گرفت ...',
                        style: TextStyle(height: 1.9),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'نظرات کاربران',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          TextButton(onPressed: () {}, child: Text('ثبت نظر')),
                        ],
                      ),
                    ]),
                  ),
                ),
                CommentList(productId: widget.product.id),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
