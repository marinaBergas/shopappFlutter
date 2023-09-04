// ignore_for_file: sized_box_for_whitespace

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/orders.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;
  const OrderItem({super.key, required this.order});

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(5),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${widget.order.amount}'),
            subtitle: Text(
                DateFormat('dd MM yyyy  hh:mm').format(widget.order.dateTime)),
            trailing: IconButton(
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
                icon: _expanded
                    ? const Icon(Icons.expand_less)
                    : const Icon(Icons.expand_more)),
                    
          ),
          if (_expanded)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 4),
              height: min(widget.order.products.length * 20 + 10, 100),
              child: ListView(
                children: 
                  widget.order.products
                      .map((product) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(product.title,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              Text('${product.quantity} X \$${product.price}',style: const TextStyle(color: Colors.grey,fontSize: 18),)
                            ],
                          ))
                      .toList()
                ,
              ),
            )
        ],
      ),
    );
  }
}
