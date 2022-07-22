import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shop_project/data/repo/auth_repository.dart';
import 'package:shop_project/data/repo/cart_repository.dart';
import 'package:shop_project/ui/auth/auth.dart';
import 'package:shop_project/ui/cart/bloc/cart_bloc.dart';
import 'package:shop_project/ui/cart/price_info.dart';
import 'package:shop_project/ui/shipping/shipping.dart';
import 'package:shop_project/ui/widget/empty_state.dart';
import 'cart_item.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final RefreshController _refreshController = RefreshController();
  late final CartBloc? cartBloc;
  StreamSubscription? stateStreamSubscription;
  bool cartIsSuccess = false;
  @override
  void initState() {
    super.initState();
    AuthRepository.authChangeNotifier.addListener(authChangeNotifierListener);
  }

  @override
  void dispose() {
    super.dispose();
    AuthRepository.authChangeNotifier
        .removeListener(authChangeNotifierListener);
    cartBloc?.close();
    stateStreamSubscription?.cancel();
  }

  void authChangeNotifierListener() {
    cartBloc?.add(CartAuthInfoChanged(AuthRepository.authChangeNotifier.value));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Visibility(
          visible: cartIsSuccess,
          child: Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(left: 48, right: 48),
              child: FloatingActionButton.extended(
                  onPressed: () {
                    final state = cartBloc!.state;
                    if (state is CartSuccess) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ShippingScreen(
                                payablePrice: state.cartResponse.payablePrice,
                                shippingCost: state.cartResponse.shippingCost,
                                totalPrice: state.cartResponse.totalPrice,
                              )));
                    }
                  },
                  label: const Text('پرداخت'))),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        appBar: AppBar(
          centerTitle: true,
          title: const Text('سبد خرید'),
        ),
        body: BlocProvider<CartBloc>(
          create: (context) {
            final bloc = CartBloc(cartRepository);
            stateStreamSubscription = bloc.stream.listen((state) {
              setState(() {
                cartIsSuccess = state is CartSuccess;
              });
              if (_refreshController.isRefresh) {
                if (state is CartSuccess) {
                  _refreshController.refreshCompleted();
                } else if (state is CartError) {
                  _refreshController.refreshFailed();
                }
              }
            });
            cartBloc = bloc;
            bloc.add(CartStarted(AuthRepository.authChangeNotifier.value));
            return bloc;
          },
          child: BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              if (state is CartLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is CartError) {
                return Center(
                  child: Text(state.exeption.message),
                );
              } else if (state is CartSuccess) {
                return SmartRefresher(
                  header: const ClassicHeader(
                    completeText: 'با موفقیت انجام شد',
                    refreshingText: 'در حال بروزرسانی',
                    idleText: 'پایین بکشید',
                    releaseText: 'رها کنید',
                    failedText: 'خطای نامشخص',
                    completeIcon: Icon(
                      CupertinoIcons.checkmark_circle,
                      color: Colors.green,
                    ),
                  ),
                  controller: _refreshController,
                  onRefresh: () {
                    cartBloc?.add(CartStarted(
                        AuthRepository.authChangeNotifier.value,
                        isRefreshing: true));
                  },
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 40),
                    itemCount: state.cartResponse.cartItems.length + 1,
                    itemBuilder: (context, index) {
                      if (index < state.cartResponse.cartItems.length) {
                        final data = state.cartResponse.cartItems[index];
                        return CartItem(
                          data: data,
                          onDeleteButtonClick: () {
                            cartBloc?.add(CartDeleteButtonClicked(data.id));
                          },
                          onMinusButtonClick: () {
                            cartBloc?.add(MinusCountButtonClicked(data.id));
                          },
                          onPlusButtonClick: () {
                            cartBloc?.add(PlusCountButtonClicked(data.id));
                          },
                        );
                      } else {
                        return PriceInfo(
                            payablePrice: state.cartResponse.payablePrice,
                            shippingCost: state.cartResponse.shippingCost,
                            totalPrice: state.cartResponse.totalPrice);
                      }
                    },
                  ),
                );
              } else if (state is AuthRequired) {
                return EmptyView(
                    message:
                        'برای مشاهده سبد خرید لطفا وارد حساب کاربری خود شوید',
                    callToAction: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const AuthScreen()));
                        },
                        child: const Text('ورود به حساب کاربری')),
                    image: SvgPicture.asset(
                      'assets/img/auth_required.svg',
                      width: 120,
                    ));

                // SizedBox(
                //   width: MediaQuery.of(context).size.width,
                //   child: Column(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     crossAxisAlignment: CrossAxisAlignment.center,
                //     children: [
                //       const Text('وارد حساب کاربری خود شوید'),
                //       ElevatedButton(
                //           onPressed: () {
                //             Navigator.of(context).push(MaterialPageRoute(
                //                 builder: (context) => const AuthScreen()));
                //           },
                //           child: const Text('ورود'))
                //     ],
                //   ),
                // );
              } else if (state is CartEmpty) {
                return EmptyView(
                    message: 'محصولی در سبد خرید شما نیست!',
                    image: SvgPicture.asset(
                      'assets/img/empty_cart.svg',
                      width: 200,
                    ));
              } else {
                throw Exception('خطای نامشخص رخ داده است.');
              }
            },
          ),
        )

        // ValueListenableBuilder<AuthInfo?>(
        //   valueListenable: AuthRepository.authChangeNotifier,
        //   builder: (context, state, child) {
        //     bool isAuthenticated = state != null && state.accessToken.isNotEmpty;
        //     return SizedBox(
        //       width: MediaQuery.of(context).size.width,
        //       child: Column(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         crossAxisAlignment: CrossAxisAlignment.center,
        //         children: [
        //           Text(isAuthenticated
        //               ? 'خوش آمدید'
        //               : 'لطفا وارد حساب کاربری خود شوید'),
        //           !isAuthenticated
        //               ? ElevatedButton(
        //                   onPressed: () {
        //                     Navigator.of(context, rootNavigator: true).push(
        //                         MaterialPageRoute(
        //                             builder: (context) => const AuthScreen()));
        //                   },
        //                   child: const Text('ورود'))
        //               : ElevatedButton(
        //                   onPressed: () {
        //                     authRepository.signOut();
        //                   },
        //                   child: const Text('خروج'))
        //         ],
        //       ),
        //     );
        //   },
        // ),
        );
  }
}
