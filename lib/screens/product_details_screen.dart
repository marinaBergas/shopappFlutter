// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_providers.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const routeName = '/product-detail';

  const ProductDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productId = (ModalRoute.of(context) as dynamic).settings.arguments;
    final currentProduct = Provider.of<Products>(context).findById(productId);
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(currentProduct.title),
      //   backgroundColor: Theme.of(context).primaryColor,
      // ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(currentProduct.title),
              background: Hero(
                tag: currentProduct.id,
                child: Image.network(
                  currentProduct.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            backgroundColor: Colors.blue,
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            const SizedBox(
              height: 10,
            ),
            Text(
              '\$${currentProduct.price}',
              style: const TextStyle(color: Colors.grey, fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 10,
            ),
            //soft wrap wraped on new lines if there is no more space
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                width: double.infinity,
                child: Text(
                  currentProduct.description,
                  textAlign: TextAlign.center,
                  softWrap: true,
                )),
            const SizedBox(
              height: 800,
            )
          ])),
        ],
      ),
    );
  }
}
