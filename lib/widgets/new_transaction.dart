// ignore_for_file: depend_on_referenced_packages, unnecessary_null_comparison, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'adaptive_text_button.dart';

class NewTransaction extends StatefulWidget {
  final Function fun;
  const NewTransaction(this.fun, {super.key});

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final inputTitle = TextEditingController();
  final inputAmount = TextEditingController();
  DateTime inputDate = DateTime.now();

  void _checkTx() {
    if (inputAmount.text.toString().isEmpty ||
        inputTitle.text.toString().isEmpty ||
        inputDate == null ||
        double.parse(inputAmount.text) <= 0) {
      return;
    }

    widget.fun(inputTitle.text, double.parse(inputAmount.text), inputDate);
    Navigator.of(context).pop();
  }

  void _ShowDate() {
  showDatePicker(
      context: context,
      initialDate: inputDate,
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
    ).then((date) => {
          if (date != null)
            {
              setState(
                () {
                  inputDate = date;
                },
              )
            }
        });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          top: 10,
          right: 10,
          left: 10,
          bottom: MediaQuery.of(context).viewInsets.bottom + 10,
        ),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: "Title"),
              controller: inputTitle,
            ),
            TextField(
              decoration: const InputDecoration(labelText: "Amount"),
              controller: inputAmount,
              keyboardType: TextInputType.number,
            ),
            SizedBox(
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Picked Date: ${DateFormat.yMd().format(inputDate)}"),
                  AdaptiveTextButton("Choose Date", _ShowDate)
                ],
              ),
            ),
            ElevatedButton(
              onPressed: _checkTx,
              child: const Text(
                "Add Transaction",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
