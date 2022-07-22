import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_project/common/exeption.dart';

class AppErrorWidget extends StatelessWidget {
  final AppExeption exeption;
  final GestureTapCallback onPressed;
  const AppErrorWidget({
    Key? key,required this.exeption,required this.onPressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(exeption.message),
          ElevatedButton(
              onPressed: onPressed,
              child: const Text('تلش دوباره')),
        ],
      ),
    );
  }
}