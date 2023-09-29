import 'package:expense_tracker/widgets/expenses_list/expense_card.dart';
import 'package:flutter/material.dart';
import '../../models/expense.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList(
      {super.key, required this.expenses, required this.onRemoveExpense});

  final List<Expense> expenses;
  final void Function(Expense expense) onRemoveExpense;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (context, index) => Dismissible(
          onDismissed: (direction) {
            onRemoveExpense(expenses[index]);
          },
          background: Container(
            color: Theme.of(context)
                .colorScheme
                .error
                .withOpacity(0.5), // appears while removing
          ),
          key: ValueKey(expenses[index]),
          child: ExpenseCard(expenses[index])),
    );
  }
}
