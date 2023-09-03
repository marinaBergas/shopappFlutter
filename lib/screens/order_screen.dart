import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart' ;

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderData=Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('order'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ListView.builder(itemBuilder: (ctx,index)=> OrderItem(order: orderData.orders[index]),itemCount: orderData.orders.length,),
    );
  }
}