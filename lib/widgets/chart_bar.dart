// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final day;
  final amount;
  final amountPercent;
  const ChartBar(this.day, this.amount, this.amountPercent, {super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constrains) {
        return Column(
          children: [
            SizedBox(
              height: (constrains.maxHeight) * 0.15,
              child: FittedBox(
                child: Text(
                  "\$${amount.toStringAsFixed(0)}",
                ),
              ),
            ),
            Container(
                margin: EdgeInsets.symmetric(
                    vertical: (constrains.maxHeight) * 0.05),
                height: (constrains.maxHeight) * 0.6,
                width: 10,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromRGBO(220, 220, 220, 1),
                          border: Border.all(width: 1.0, color: Colors.grey)),
                    ),
                    FractionallySizedBox(
                      heightFactor: amountPercent,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    )
                  ],
                )),
            SizedBox(
              height: (constrains.maxHeight) * 0.15,
              child: FittedBox(
                child: Text(day),
              ),
            ),
          ],
        );
      },
    );
  }
}
