import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '/providers/product_providers.dart';

class ProductDetailScreen extends StatelessWidget {
  static String routeName = "/product_detail";

  const ProductDetailScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final String id = ModalRoute.of(context)?.settings.arguments as String;
    final loadedProduct =
        Provider.of<Products>(context, listen: false).findById(id);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
    );
  }
}
