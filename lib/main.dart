import 'package:flutter/material.dart';
import 'package:shop_project/data/repo/auth_repository.dart';
import 'package:shop_project/data/source/favorite_manager.dart';
import 'package:shop_project/theme/theme.dart';
import 'package:shop_project/ui/auth/auth.dart';
import 'package:shop_project/ui/home/home.dart';
import 'package:shop_project/ui/root.dart';

void main() async{
  await FavoriteManage.init();
  WidgetsFlutterBinding.ensureInitialized();
  authRepository.LoadAuthInfo();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const defaultTextStyle = TextStyle(
        fontFamily: 'iranSans', color: LightThemeColor.primaryTextColor);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        //تعریف استایل های مربوط به تکست در کل پروژه
        textTheme: TextTheme(
          button: defaultTextStyle,
          subtitle1:
              defaultTextStyle.apply(color: LightThemeColor.secondaryTextColor),
          bodyText2: defaultTextStyle,
          caption:
              defaultTextStyle.apply(color: LightThemeColor.secondaryTextColor),
          headline6: defaultTextStyle.copyWith(
              fontWeight: FontWeight.bold, fontSize: 18),
        ),
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        hintColor: LightThemeColor.secondaryTextColor,
        inputDecorationTheme: InputDecorationTheme(
          border:OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: LightThemeColor.primaryColor.withOpacity(0.2)))
        ),
        appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: LightThemeColor.primaryColor,
            elevation: 0),
        snackBarTheme: SnackBarThemeData(
            contentTextStyle: defaultTextStyle.apply(color: Colors.white)),
        colorScheme: const ColorScheme.light(
          primary: LightThemeColor.primaryColor,
          secondary: LightThemeColor.secondaryColor,
          //چیزایی که روی رنگ سکندیری قرار میگیرن مثل دکمه فلوت اکشن باتن و نوشته روش که باید سفید باشه
          onSecondary: Colors.white,
        ),
      ),
      //استفاده از تابع تکست دایرکشن جهت راست چین کردن کل پروژه
      home: const Directionality(
          textDirection: TextDirection.rtl, child: RootScreen()),
    );
  }
}
