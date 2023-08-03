import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

const uuid = Uuid();

enum iCategory { food, travel, leisure, work }

const categoryIcons = {
  iCategory.food: Icons.lunch_dining_rounded,
  iCategory.travel: Icons.flight_takeoff,
  iCategory.leisure: Icons.movie,
  iCategory.work: Icons.work,
};

class Expense {
  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  }) : id = uuid.v4();

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final iCategory category;

  String get formattedDate {
    return formatter.format(date);
  }
}

class ExpenseBucket {
  ExpenseBucket({required this.category, required this.expenses});

  ExpenseBucket.forCategory(List<Expense> allExpense, this.category) 
   : expenses = allExpense.where((expense) => expense.category == category).toList(); 
  

  final iCategory category;
  final List<Expense> expenses;

  double get totalExpenses {
    double sum = 0;

    for (final expense in expenses) {
      sum = sum + expense.amount;
    }

    return sum;
  }
}
