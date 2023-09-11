import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = '/orders';
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  //to avoid future run again if some thing change and widget rebuild
  //we call it and store it in afuture var
  late Future _ordersFuture;
  Future _obtainOrdersFuture(){
return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }
  @override
  void initState() {
_ordersFuture=_obtainOrdersFuture();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // final orderData = Provider.of<Orders>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('order'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        drawer: const AppDrawer(),
        body: FutureBuilder(
            future:
               _ordersFuture,
            builder: (ctx, datasnapshot) {
              if (datasnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                if (datasnapshot.error == null) {
                  return Consumer<Orders>(builder: (context,orderData,child)=> ListView.builder(
                    itemBuilder: (ctx, index) =>
                        OrderItem(order: orderData.orders[index]),
                    itemCount: orderData.orders.length,
                  ));
                }else{
                  //....do error handling
                  return const Center(child: Text('an error accurred'),);
                }
              }
            })
        //   _isLoading?const Center(child: CircularProgressIndicator()):ListView.builder(
        //   itemBuilder: (ctx, index) => OrderItem(order: orderData.orders[index]),
        //   itemCount: orderData.orders.length,
        // ),
        );
  }
}
