import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/product_details_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/cart_screen.dart';
import './screens/order_screen.dart';

import './providers/products_providers.dart';
import './providers/orders.dart';
import './providers/cart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Products(),
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
                ChangeNotifierProvider(
          create: (_) =>  Orders(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter My Shop',
        theme: ThemeData(
            // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
            colorScheme: ColorScheme.fromSwatch().copyWith(
                secondary: Colors.deepOrange,
                error: Colors.red // Your accent color
                ),
            useMaterial3: true,
            primaryColor: Colors.purple,
            textTheme: ThemeData.light().textTheme.copyWith(
                  bodySmall:
                      const TextStyle(color: Color.fromRGBO(20, 51, 51, 1)),
                  bodyMedium:
                      const TextStyle(color: Color.fromRGBO(20, 51, 51, 1)),
                  titleSmall: const TextStyle(
                      fontFamily: 'OpenSans',
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      color: Colors.black),
                  titleMedium: const TextStyle(
                      fontFamily: 'RobotoCondensed',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
            scaffoldBackgroundColor: const Color.fromARGB(255, 233, 219, 219)),
        home: const ProductsOverviewScreen(),
        routes: {
          ProductDetailsScreen.routeName: (context) =>
              const ProductDetailsScreen(),
          CartScreen.routeName: (context) => const CartScreen(),
          OrderScreen.routeName:(context)=>const OrderScreen()
        },
      ),
    );
  }
}
