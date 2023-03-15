// ignore_for_file: must_be_immutable, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/models/transaction.dart';

import 'chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> transactions;
  Chart(this.transactions, {super.key});
  double amountWeekSum = 0;
  List<Map<String, Object>> get txGroup {
    return List.generate(7, (index) {
      var weekDay = DateTime.now().subtract(Duration(days: index));
      double amountSum = 0.0;
      for (var i = 0; i < transactions.length; i++) {
        if (transactions[i].date.day == weekDay.day &&
            transactions[i].date.month == weekDay.month &&
            transactions[i].date.year == weekDay.year) {
          amountSum += transactions[i].amount;
        }
      }
      amountWeekSum += amountSum;
      return {"day": DateFormat.E().format(weekDay), "amount": amountSum};
    }).reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: (txGroup).map(
            (data) {
              return Flexible(
                fit: FlexFit.tight,
                child: ChartBar(
                  data["day"].toString(),
                  double.parse(data["amount"].toString()),
                  amountWeekSum == 0
                      ? 0.0
                      : (data["amount"] as double) / amountWeekSum,
                ),
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}
