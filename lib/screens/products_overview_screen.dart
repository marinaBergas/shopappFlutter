import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:shopapp/providers/cart.dart';
import '../widgets/product_grid.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';
import './cart_screen.dart';
import '../widgets/app_drawer.dart';
import '../providers/products_providers.dart';

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
  var _showFavoritesONly = false;
    var _isInit = true;
var _isLoading=false;
//   @override
//   void initState() {
// //Provider.of<Products>(context).fetchAndSetProducts();  //won`t work
//     Future.delayed(Duration.zero).then((_) {
//       Provider.of<Products>(context).fetchAndSetProducts();
//     });
//     super.initState();
//   }

@override
  void didChangeDependencies() {
    if(_isInit){
          setState(() {
      _isLoading = true;
    });
     Provider.of<Products>(context).fetchAndSetProducts().then((_) {
               setState(() {
      _isLoading = false;
    });

     });

    }
    _isInit=false;
    super.didChangeDependencies();
  }
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
                  _showFavoritesONly = true;
                } else {
                  _showFavoritesONly = false;
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
          ),
          // Badge(child: IconButton(icon: const Icon(Icons.shopping_cart), onPressed: () {  },),)
          Consumer<Cart>(
            builder: (ctx, cartData, buttonChild) => CustomeBadge(
              value: cartData.itemCount.toString(),
              child: buttonChild!,
            ),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          )
        ],
      ),
      drawer: const AppDrawer(),
      //render item on the screen not all items
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          :ProductGrid(showFavoritesONly: _showFavoritesONly),
    );
  }
}
