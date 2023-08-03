import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:expense_tracker/model/expense.dart';

final formatter = DateFormat.yMd();

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectDate;
  iCategory _selectedCategory = iCategory.leisure;

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );

    setState(() {
      _selectDate = pickedDate;
    });
  }

  void _showDialog() {
    if(Platform.isIOS) {
      showCupertinoDialog(context: context, builder: ((context) => CupertinoAlertDialog(
          title: const Text(
                'Invalid input',
                style: TextStyle(color: Colors.red),
              ),
              content: const Text(
                  'Please make sure a valid input, amount, date and category was entered.'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Okay')),
              ],
            )
      ));
    } else {
  showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: const Text(
                'Invalid input',
                style: TextStyle(color: Colors.red),
              ),
              content: const Text(
                  'Please make sure a valid input, amount, date and category was entered.'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                    },
                    child: const Text('Okay')),
              ],
            );
          });
    }
  }

  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectDate == null) {
    
          _showDialog();

      return;
    }

    widget.onAddExpense(
      Expense(
        title: _titleController.text,
        amount: enteredAmount,
        date: _selectDate!,
        category: _selectedCategory,
      ),
    );

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace  = MediaQuery.of(context).viewInsets.bottom;
    return SingleChildScrollView(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
          child: Column(children: [
            TextField(
              controller: _titleController,
              maxLength: 50,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(label: Text('Title')),
            ),
            Row(children: [
              Expanded(
                child: TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      prefixText: '₹ ', label: Text('Amount')),
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(_selectDate == null
                        ? 'No date selected'
                        : formatter.format(_selectDate!)),
                    IconButton(
                      onPressed: _presentDatePicker,
                      icon: const Icon(Icons.calendar_month),
                    ),
                  ],
                ),
              )
            ]),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                DropdownButton(
                  value: _selectedCategory,
                  items: iCategory.values
                      .map(
                        (iCategory) => DropdownMenuItem(
                          value: iCategory,
                          child: Text(
                            iCategory.name.toUpperCase(),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: ((value) {
                    if (value == null) {
                      return;
                    }
                    setState(() {
                      _selectedCategory = value;
                    });
                  }),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: _submitExpenseData,
                  child: const Text('Save Expense'),
                ),
              ],
            )
          ]),
        ),
      ),
    );
  }
}
