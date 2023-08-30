import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/product_details_screen.dart';
import './screens/products_overview_screen.dart';
import './providers/products_providers.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value (
      value: Products(),
      child: MaterialApp(
        title: 'Flutter My Shop',
        theme: ThemeData(
          // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
                   colorScheme: ColorScheme.fromSwatch().copyWith(
                secondary: Colors.deepOrange, error: Colors.red // Your accent color
                ),
          useMaterial3: true,
          primaryColor: Colors.purple
        ),
        home: const ProductsOverviewScreen(),
        routes: {
          ProductDetailsScreen.routeName:(context)=>const ProductDetailsScreen()
        },
      ),
    );
  }
}
