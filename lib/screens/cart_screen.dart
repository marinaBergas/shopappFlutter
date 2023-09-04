import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart' show Cart;
import '../widgets/cart_item.dart';
import '../providers/orders.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final orders = Provider.of<Orders>(context,listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('cart'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  //add space between item in row
                  const Spacer(),
                  Chip(
                    label: Text('\$${cart.totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                            color: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.color)),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  TextButton(
                    onPressed: () {
                      orders.addOrder(
                          cart.items.values.toList(), cart.totalAmount);
                          cart.clear();
                    },
                    style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context).primaryColor),
                    child: const Text('ORDER NOW'),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          //listView ON column direct doest work correctly
          Expanded(
              child: ListView.builder(
            itemBuilder: (ctx, index) => CartItem(
              id: cart.items.values.toList()[index].id,
              price: cart.items.values.toList()[index].price,
              quantity: cart.items.values.toList()[index].quantity,
              title: cart.items.values.toList()[index].title,
              productId: cart.items.keys.toList()[index],
            ),
            itemCount: cart.items.length,
          ))
        ],
      ),
    );
  }
}
