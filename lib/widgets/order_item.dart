import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/orders.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem orders;
  const OrderItem(this.orders, {super.key});

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text("\$${widget.orders.amount}"),
            subtitle:
                Text(DateFormat("dd MM yyyy hh:mm").format(widget.orders.time)),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                _expanded = !_expanded;
                setState(() {});
              },
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeIn,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
            height:
                _expanded ? min(widget.orders.list.length * 10 + 50, 100) : 0,
            child: ListView(
                children: ((widget.orders.list).map((prod) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    prod.title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${prod.quantity} x \$${prod.price}",
                    style: const TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                ],
              );
            }).toList())),
          )
        ],
      ),
    );
  }
}
