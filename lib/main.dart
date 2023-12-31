// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/product_details_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/cart_screen.dart';
import './screens/order_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/user_products_screen.dart';
import './screens/auth_screen.dart';
import './screens/splash_screen.dart';
import './providers/products_providers.dart';
import './providers/orders.dart';
import './providers/cart.dart';
import './providers/auth.dart';
import './helpers/custom_route.dart';

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
            create: (_) => Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            update: (ctx, auth, previousProduct) =>
                Products(auth.token, auth.userId, previousProduct!.items),
            create: (ctx) => Products('', '', []),
          ),
          ChangeNotifierProvider(
            create: (_) => Cart(),
          ),
          // ChangeNotifierProvider(
          //   create: (_) => Orders(),
          // )
          ChangeNotifierProxyProvider<Auth, Orders>(
            update: (ctx, auth, previousOrder) =>
                Orders(auth.token, previousOrder!.orders, auth.userId),
            create: (ctx) => Orders('', [], ''),
          )
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, child) => MaterialApp(
            title: 'Flutter My Shop',
            theme: ThemeData(
                // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
                pageTransitionsTheme: PageTransitionsTheme(builders: {
                  TargetPlatform.android: CustomePageTransitionBuilder(),
                  TargetPlatform.iOS: CustomePageTransitionBuilder(),
                }),
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
                scaffoldBackgroundColor:
                    const Color.fromARGB(255, 233, 219, 219)),
            home: auth.isAuth
                ? const ProductsOverviewScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, authResultSnapshot) =>
                        authResultSnapshot.connectionState ==
                                ConnectionState.waiting
                            ? const SplashScreen()
                            : const AuthScreen(),
                  ),
            routes: {
              ProductDetailsScreen.routeName: (context) =>
                  const ProductDetailsScreen(),
              CartScreen.routeName: (context) => const CartScreen(),
              ProductsOverviewScreen.routeName: (context) =>
                  const ProductsOverviewScreen(),
              OrderScreen.routeName: (context) => const OrderScreen(),
              UserProductsScreen.routeName: (context) =>
                  const UserProductsScreen(),
              EditProductScreen.routeName: (context) =>
                  const EditProductScreen(),
            },
          ),
        ));
  }
}
