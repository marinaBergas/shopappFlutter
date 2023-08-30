import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './product_item.dart';
import '../providers/products_providers.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({super.key});


  @override
  Widget build(BuildContext context) {
    final productData=Provider.of<Products>(context);
    final productItems=productData.items;
    return GridView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: productItems.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10),
        itemBuilder: (ctx, index) {
          return ChangeNotifierProvider(child:const ProductItem(
              // imageUrl: productItems[index].imageUrl,
              // id: productItems[index].id,
              // title: productItems[index].title
              ),
              create: (BuildContext context)=> productItems[index],
               ); 
        });
  }
}
