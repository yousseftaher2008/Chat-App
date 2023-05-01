import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/products_overview_screen.dart';
import '../widgets/splash_screen.dart';
import '../providers/auth.dart';
import '../providers/cart.dart';
import '../providers/orders.dart';
import '../screens/add_product.dart';
import '../screens/auth_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/user_product_screen.dart';

import '../providers/product_providers.dart';
import '../screens/product_detail_screen.dart';
import '../screens/orders_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (ctx) => Products("", "", []),
          update: (ctx, auth, previousProducts) =>
              Products(auth.token, auth.userId, previousProducts!.products),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (ctx) => Orders("", "", []),
          update: (ctx, auth, previousProducts) =>
              Orders(auth.token, auth.userId, previousProducts!.orders),
        ),
      ],
      child: MaterialApp(
        title: 'MyShop',
        theme: ThemeData(
          fontFamily: "Anton",
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
              .copyWith(secondary: Colors.deepOrange),
        ),
        home: Consumer<Auth>(
          builder: (ctx, auth, _) => auth.isAuth
              ? const ProductOverviewScreen()
              : FutureBuilder(
                  builder: (context, authSnapShot) =>
                      authSnapShot.connectionState == ConnectionState.waiting
                          ? const SplashScreen()
                          : const AuthScreen(),
                  future: auth.autoLogin(),
                ),
        ),
        routes: {
          ProductDetailScreen.routeName: (context) =>
              const ProductDetailScreen(),
          CartScreen.routeName: (context) => const CartScreen(),
          OrdersScreen.routeName: (context) => const OrdersScreen(),
          UserProductScreen.routeName: (context) => const UserProductScreen(),
          AddProductScreen.routeName: (context) => const AddProductScreen(),
        },
      ),
    );
  }
}
