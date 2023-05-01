import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/screens/cart_screen.dart';

import '../providers/product_providers.dart';
import '../widgets/drawer.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';

enum FilterOptions {
  favorites,
  all,
}

class ProductOverviewScreen extends StatefulWidget {
  const ProductOverviewScreen({super.key});

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var showFavorites = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      try {
        await Provider.of<Products>(context).getData().then((_) => {
              setState(() {
                _isLoading = false;
              })
            });
      } catch (_) {
        await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: const Text("An error occurred"),
                  content: const Text(
                      "Something went wrong.\nTry to restart the application"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed('/');
                        },
                        child: const Text("Ok")),
                  ],
                ));
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Shop"),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions value) {
              if (value == FilterOptions.favorites) {
                showFavorites = true;
              } else {
                showFavorites = false;
              }
              setState(() {});
            },
            itemBuilder: ((_) => const [
                  PopupMenuItem(
                    value: FilterOptions.favorites,
                    child: Text("Only Favorites"),
                  ),
                  PopupMenuItem(
                    value: FilterOptions.all,
                    child: Text("Show all"),
                  ),
                ]),
            icon: const Icon(Icons.more_vert),
          ),
          Consumer<Cart>(
            builder: (_, carted, __) => Badge(
                IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () {
                    Navigator.of(context).pushNamed(CartScreen.routeName);
                  },
                ),
                carted.itemCount.toString()),
          ),
        ],
      ),
      drawer: const MyDrawer(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(showFavorites),
    );
  }
}
