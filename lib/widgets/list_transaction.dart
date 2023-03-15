// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';

import '/models/transaction.dart';
import 'transaction_item.dart';

class ListTransaction extends StatelessWidget {
  final List<Transaction> transactions;
  final Function fun;
  const ListTransaction(this.transactions, this.fun, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      padding: const EdgeInsets.all(5),
      child: transactions.isEmpty
          ? LayoutBuilder(builder: (ctx, constrains) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    "No transactions added yet",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    height: constrains.maxHeight * 0.6,
                    child: Image.asset("assets/images/waiting.png",
                        fit: BoxFit.cover),
                  ),
                ],
              );
            })
          : ListView.builder(
              itemBuilder: (context, index) {
                return TransactionItem(
                  transaction: transactions[index],
                  fun: fun,
                  index: index,
                );
              },
              itemCount: transactions.length,
            ),
    );
  }
}
