import 'package:flutter/material.dart';
import '../widgets/product_grid.dart';
enum FilterOptions {
  favorites,
  all,
}

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({super.key});

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showFavoritesONly=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                              if (selectedValue == FilterOptions.favorites) {
                _showFavoritesONly=true;
              } else {
                _showFavoritesONly=false;
              }
              });

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
      body:  ProductGrid(showFavoritesONly: _showFavoritesONly),
    );
  }
}
