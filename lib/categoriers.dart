// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'category_item.dart';
import 'dummy_data.dart';
class Categories extends StatelessWidget {
  const Categories({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView(
      children:  (Dummy_Categories).map((catData) => CategoryItem(catData.title, catData.color)).toList(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 200,
      childAspectRatio: 3 / 2,
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      ),
    );
  }
}
