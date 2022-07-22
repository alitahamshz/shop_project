import 'package:flutter/material.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:const Text('کفش های ورزشی')),
      body: ListView.builder(itemBuilder: (context,index){
        return Container();
      }),
      
    );
  }
}