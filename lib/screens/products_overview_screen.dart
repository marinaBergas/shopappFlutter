import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/product_grid.dart';
import '../providers/products_providers.dart';
enum FilterOptions {
  favorites,
  all,
}

class ProductsOverviewScreen extends StatelessWidget {
  const ProductsOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              // ignore: avoid_print
              if (selectedValue == FilterOptions.favorites) {
                productData.showFavourites();
              } else {
                productData.showAll();
              }
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: FilterOptions.favorites,
                child: Text('only favorite !'),
              ),
              const PopupMenuItem(
                value: FilterOptions.all,
                child: Text('show all'),
              ),
            ],
            icon: const Icon(Icons.more_vert),
          )
        ],
      ),
      //render item on the screen not all items
      body: const ProductGrid(),
    );
  }
}
