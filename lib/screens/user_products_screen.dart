
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/edit_product_screen.dart';
import '../providers/products_providers.dart';
import '../widgets/user_product_item.dart';
import '../widgets/app_drawer.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName='/user-products';
  const UserProductsScreen({super.key});

Future<void> _refreshProducts(context) async{
await Provider.of<Products>(context,listen: false).fetchAndSetProducts(true);
}
  @override
  Widget build(BuildContext context) {
    // final productData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('your products'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          )
        ],
      ),
            drawer: const AppDrawer(),
            //to fetch new api data
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder:(ctx,snapShots)=> snapShots.connectionState== ConnectionState.waiting? 
        const Center(child: CircularProgressIndicator()):
        RefreshIndicator(
          onRefresh:()=> _refreshProducts(context),
          child: Consumer<Products>(
            builder:(ctx,productData,_)=> Padding(
              padding: const EdgeInsets.all(8),
              child: ListView.builder(
                  itemBuilder: (_, i) => Column(
                    children: [
                      UserProductItem(
                          title: productData.items[i].title,
                          imageUrl: productData.items[i].imageUrl,id: productData.items[i].id),
                  
                          const Divider()
                    ],
                  ),
                  itemCount: productData.items.length),
            ),
          ),
        ),
      ),
    );
  }
}
