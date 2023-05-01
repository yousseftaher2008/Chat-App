import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/orders.dart';
import 'package:shop/widgets/cart_item.dart' as ci;

import '../providers/cart.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  static String routeName = "/cart";

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  void fun() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final orders = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Cart"),
      ),
      body: Column(children: [
        Card(
          margin: const EdgeInsets.all(10),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                const Text("Total amount"),
                const Spacer(),
                Chip(
                  label: Text("\$${cart.totalAmount.toStringAsFixed(2)}"),
                  labelStyle: const TextStyle(
                    color: Colors.white,
                  ),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                OrderButton(cart: cart, orders: orders),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemBuilder: ((ctx, i) {
              return ci.CartItem(
                cart.items.values.toList()[i].id,
                cart.items.keys.toList()[i],
                cart.items.values.toList()[i].price,
                cart.items.values.toList()[i].quantity,
                cart.items.values.toList()[i].title,
                fun,
              );
            }),
            itemCount: cart.itemCount,
          ),
        )
      ]),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cart,
    required this.orders,
  }) : super(key: key);

  final Cart cart;
  final Orders orders;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    return TextButton(
      onPressed: (widget.cart.totalAmount < 1 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              try {
                await widget.orders.addOrder(
                    widget.cart.totalAmount, widget.cart.items.values.toList());
                widget.cart.clear();
              } catch (_) {
                scaffold.hideCurrentSnackBar();
                scaffold.showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Order failed!",
                      textAlign: TextAlign.center,
                    ),
                    duration: Duration(seconds: 2),
                  ),
                );
              }

              setState(() {
                _isLoading = false;
              });
            },
      child: _isLoading
          ? const CircularProgressIndicator()
          : const Text("Order Now"),
    );
  }
}
