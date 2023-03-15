import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    super.key,
    required this.transaction,
    required this.index,
    required this.fun,
  });

  final Transaction transaction;
  final int index;
  final Function fun;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
      leading: CircleAvatar(
        radius: 30,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: FittedBox(
            child: Text("\$${transaction.amount.toStringAsFixed(2)}"),
          ),
        ),
      ),
      title: Text(transaction.title),
      subtitle: Text(DateFormat.yMMMd().format(transaction.date)),
      trailing: MediaQuery.of(context).size.width > 250
          ? TextButton.icon(
              onPressed: () {
                fun(index);
              },
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).errorColor,
              ),
              label: Text(
                "Delete",
                style: TextStyle(color: Theme.of(context).errorColor),
              ),
            )
          : IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                fun(index);
              },
              color: Theme.of(context).errorColor,
            ),
    ));
  }
}
