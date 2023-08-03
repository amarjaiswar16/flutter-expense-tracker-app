import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/expenses_list.dart/expenses_list.dart';
import 'package:expense_tracker/model/expense.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpense = [
    Expense(
        title: 'Flutter Course',
        amount: 3399,
        date: DateTime.now(),
        category: iCategory.work),
    Expense(
        title: 'Cinema',
        amount: 499,
        date: DateTime.now(),
        category: iCategory.leisure),
  ];

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) => NewExpense(
              onAddExpense: _addExpense,
            ));
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpense.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpense.indexOf(expense);
    setState(() {
      _registeredExpense.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Expense deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registeredExpense.insert(expenseIndex, expense);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(context) {

   // print(MediaQuery.of(context).size.width);
   // print(MediaQuery.of(context).size.height);
   final width = MediaQuery.of(context).size.width;
    

    Widget mainContent = const Center(
      child: Text(
        'No expenses found. Start adding some!',
        style: TextStyle(fontSize: 16),
      ),
    );

    if (_registeredExpense.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpense,
        onRemoveExpense: _removeExpense,
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Flutter ExpenseTracker'), actions: [
        IconButton(
          onPressed: _openAddExpenseOverlay,
          icon: const Icon(Icons.add),
        ),
      ]),
      body:width < 600 ? Column(
        children: [
          Chart(expenses: _registeredExpense),
          Expanded(child: mainContent),
        ],
      ) : Row(children: [
           Expanded(child: Chart(expenses: _registeredExpense)),
          Expanded(child: mainContent),
      ]),
    );
  }
}
