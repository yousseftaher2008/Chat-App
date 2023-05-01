import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final String title;
  final double price;
  final int quantity;
  final Function fun;
  const CartItem(
      this.id, this.productId, this.price, this.quantity, this.title, this.fun,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        // ignore: prefer_const_constructors
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) {
        return showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: const Text("Are you sure"),
              content: const Text("Do you want to remove the item"),
              actions: [
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red)),
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("No"),
                ),
                TextButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue)),
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text("Yes"),
                )
              ],
            );
          },
        );
      },
      onDismissed: (_) {
        fun();
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: FittedBox(
                    child: Text(
                  "\$$price",
                  style: const TextStyle(color: Colors.white),
                )),
              ),
            ),
            title: Text(title),
            subtitle: Text("\$${quantity * price}"),
            trailing: Text("$quantity x"),
          ),
        ),
      ),
    );
  }
}
