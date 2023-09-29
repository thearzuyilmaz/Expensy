import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

// intl package
// can be created outside of the class below
final formatter = DateFormat.yMd();

// uuid package
// can be created outside of the class below
const uuid = Uuid();

// DON'T put ; at the end
// can be created outside of the class below
enum Category { food, travel, leisure, work }

// put ; at the end
// can be created outside of the class below
const categoryIcons = {
  Category.food: Icons.lunch_dining,
  Category.travel: Icons.flight_takeoff,
  Category.leisure: Icons.sports_volleyball,
  Category.work: Icons.work,
};

// whenever this expense class is initialized,
// a unique id will be created by the help of UUID package
class Expense {
  Expense(
      {required this.date,
      required this.amount,
      required this.title,
      required this.category})
      : id = uuid.v4();

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  // getters are computed properties based on other class properties
  // formatting "date" property of Expense class
  String get formattedDate {
    return formatter.format(date);
  }
}

// each category's total expenses
class ExpenseBucket {
  ExpenseBucket({required this.category, required this.expenses});

  ExpenseBucket.forCategory(List<Expense> allExpenses, this.category)
      : expenses = allExpenses
            .where((expense) => expense.category == category)
            .toList();

  final Category category;
  final List<Expense> expenses;

  double get totalExpenses {
    double sum = 0;
    for (var expense in expenses) {
      sum += expense.amount;
    }
    return sum;
  }
}
