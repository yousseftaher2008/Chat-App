import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/product_providers.dart';
import 'package:shop/screens/add_product.dart';
import 'package:shop/widgets/drawer.dart';
import 'package:shop/widgets/user_product_item.dart';

class UserProductScreen extends StatelessWidget {
  static String routeName = "/user_products";

  const UserProductScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context).products;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Menage your products"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AddProductScreen.routeName);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView.builder(
          itemBuilder: (_, i) => Column(
            children: [
              UserProductItem(
                products[i].id,
                products[i].title,
                products[i].imageUrl,
              ),
              const Divider()
            ],
          ),
          itemCount: products.length,
        ),
      ),
      drawer: const MyDrawer(),
    );
  }
}
