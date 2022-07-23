import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_project/data/model/auth.dart';
import 'package:shop_project/ui/auth/auth.dart';
import 'package:shop_project/ui/favorites/favoritesScreen.dart';

import '../../data/repo/auth_repository.dart';
import '../../data/repo/cart_repository.dart';

class profileScreen extends StatelessWidget {
  const profileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('پروفایل'),
        actions: [
          IconButton(
              onPressed: () {
                authRepository.signOut();
                cartRepository.cartItemCountNotifier.value = 0;
              },
              icon: Icon(Icons.exit_to_app))
        ],
      ),
      body: ValueListenableBuilder<AuthInfo?>(
          valueListenable: AuthRepository.authChangeNotifier,
          builder: (context, authInfo, child) {
            final isLogin = authInfo != null && authInfo.accessToken.isNotEmpty;
            return Center(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        width: 65,
                        height: 65,
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.only(left: 8, top: 8),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                width: 1,
                                color: Theme.of(context).dividerColor)),
                        child: Image.asset('assets/img/nike_logo.png')),
                    Text(isLogin ? 'علی رزمجو' : 'کاربر مهمان'),
                    const SizedBox(
                      height: 32,
                    ),
                    const Divider(
                      height: 2,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => FavoritesScreen()));
                      },
                      child: Container(
                        height: 56,
                        padding: const EdgeInsets.only(right: 10),
                        child: Row(
                          children: const [
                            Icon(CupertinoIcons.heart),
                            SizedBox(
                              width: 10,
                            ),
                            Text('لیست علاقه مندی ها')
                          ],
                        ),
                      ),
                    ),
                    const Divider(
                      height: 2,
                    ),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        height: 56,
                        padding: const EdgeInsets.only(right: 10),
                        child: Row(
                          children: const [
                            Icon(CupertinoIcons.cart),
                            SizedBox(
                              width: 10,
                            ),
                            Text('سوابق سفارشات')
                          ],
                        ),
                      ),
                    ),
                    const Divider(
                      height: 2,
                    ),
                    InkWell(
                      onTap: () {
                        if (isLogin) {
                          showDialog(
                              useRootNavigator: true,
                              context: context,
                              builder: (context) {
                                return Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: AlertDialog(
                                    title: const Text('خروج از حساب کاربری'),
                                    content: const Text(
                                        'آیا میخواهید از حساب خود خارج شوید'),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            authRepository.signOut();
                                            cartRepository.cartItemCountNotifier
                                                .value = 0;
                                          },
                                          child: const Text('بله')),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('خیر')),
                                    ],
                                  ),
                                );
                              });
                        } else {
                          Navigator.of(context, rootNavigator: true).push(
                              MaterialPageRoute(
                                  builder: (context) => const AuthScreen()));
                        }
                      },
                      child: Container(
                        height: 56,
                        padding: const EdgeInsets.only(right: 10),
                        child: Row(
                          children: [
                            Icon(isLogin?  CupertinoIcons.arrow_right_square:CupertinoIcons.arrow_left_square),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(isLogin
                                ? 'خروج از حساب کاریری'
                                : 'ورود به حاب کاربری'),
                          ],
                        ),
                      ),
                    ),
                    const Divider(
                      height: 2,
                    )
                  ]),
            );
          }),
    );
  }
}
