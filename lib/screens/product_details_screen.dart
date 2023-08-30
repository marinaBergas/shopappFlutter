import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_providers.dart';
class ProductDetailsScreen extends StatelessWidget {

   static const routeName='/product-detail';

  const ProductDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productId=(ModalRoute.of(context) as dynamic).settings.arguments;
    final currentProduct=Provider.of<Products>(context).findById(productId);
    return Scaffold(
      appBar: AppBar(
        title:   Text(currentProduct.title),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
