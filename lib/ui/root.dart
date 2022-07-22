import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_project/data/repo/auth_repository.dart';
import 'package:shop_project/data/repo/cart_repository.dart';
import 'package:shop_project/ui/cart/cart.dart';
import 'package:shop_project/ui/home/home.dart';
import 'package:shop_project/ui/widget/badge.dart';

const int homeIndex = 0;
const int cartIndex = 1;
const int profileIndex = 2;

class RootScreen extends StatefulWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int selectedScreenIndex = homeIndex;
  final List<int> _history = [];

  final GlobalKey<NavigatorState> _homeKey = GlobalKey();
  final GlobalKey<NavigatorState> _cartKey = GlobalKey();
  final GlobalKey<NavigatorState> _profileKey = GlobalKey();

  late final map = {
    homeIndex: _homeKey,
    cartIndex: _cartKey,
    profileIndex: _profileKey,
  };
  Future<bool> _onWillPop() async {
    final NavigatorState currentSelectedTabNavigatorstate =
        map[selectedScreenIndex]!.currentState!;
    if (currentSelectedTabNavigatorstate.canPop()) {
      currentSelectedTabNavigatorstate.pop();
      return false;
    } else if (_history.isNotEmpty) {
      setState(() {
        selectedScreenIndex = _history.last;
        _history.removeLast();
      });
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          body: IndexedStack(
            index: selectedScreenIndex,
            children: [
              Navigator(
                  key: _homeKey,
                  onGenerateRoute: (settings) => MaterialPageRoute(
                      builder: (context) => Offstage(
                          offstage: selectedScreenIndex != homeIndex,
                          child: const HomeScreen()))),
              Navigator(
                  key: _cartKey,
                  onGenerateRoute: (settings) => MaterialPageRoute(
                      builder: (context) => Offstage(
                          offstage: selectedScreenIndex != cartIndex,
                          child: const Center(
                            child: CartScreen(),
                          )))),
              Navigator(
                  key: _profileKey,
                  onGenerateRoute: (settings) => MaterialPageRoute(
                      builder: (context) => Offstage(
                            offstage: selectedScreenIndex != profileIndex,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('پروفایل'),
                                  ElevatedButton(
                                      onPressed: () {
                                        authRepository.signOut();
                                        cartRepository.cartItemCountNotifier.value = 0;
                                      },
                                      child: Text('خروج'))
                                ]),
                          ))),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
              items: [
                BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.home), label: 'خانه'),
                BottomNavigationBarItem(
                    icon: Stack(
                      clipBehavior: Clip.none,
                      children:  [
                        Icon(CupertinoIcons.cart),
                        Positioned(
                          right: -10,
                          child: ValueListenableBuilder<int>(valueListenable: cartRepository.cartItemCountNotifier,
                           builder:(context,value,child){
                             return Badge(
                            value: value,
                          );
                           })
                        ),
                      ],
                    ),
                    label: 'سبد خرید'),
                BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.person), label: 'پروفایل'),
              ],
              currentIndex: selectedScreenIndex,
              onTap: (int selectedIndex) {
                setState(() {
                  _history.remove(selectedScreenIndex);
                  _history.add(selectedScreenIndex);
                  selectedScreenIndex = selectedIndex;
                });
              }),
        ),
        onWillPop: _onWillPop);
  }

  @override
  void initState() {
    cartRepository.count();
    super.initState();
  }
}
