import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './product_item.dart';
import '../providers/products_providers.dart';

class ProductGrid extends StatelessWidget {
  final bool  showFavoritesONly;

  const ProductGrid({super.key,required this.showFavoritesONly});
  // const ProductGrid(Set<bool> set, {super.key, re this.showFavoritesONly});

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    final productItems = showFavoritesONly?productData.favoriteItems: productData.items;
    return GridView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: productItems.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10),
        itemBuilder: (ctx, index) {
          return ChangeNotifierProvider.value(
            value: productItems[index],
            child: const ProductItem(),
          );
        });
  }
}
