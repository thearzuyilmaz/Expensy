import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';
import '../models/expense.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  // Lets create some dummy data from Expense() class

  final List<Expense> _registeredExpenses = [
    //putting some objects created from Expense class
    Expense(
      title: 'Beats Flex',
      amount: 79.99,
      category: Category.leisure,
      date: DateTime.now(),
    ),
    Expense(
      title: 'Flutter Class',
      amount: 59.99,
      category: Category.work,
      date: DateTime.now(),
    ),
  ];

  void addExpense(Expense expense) {
    print(expense); //testing
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      constraints: BoxConstraints(
        minWidth: 0,
        maxWidth: MediaQuery.of(context).size.width,
      ), // form covers the full screen
      context: context,
      builder: (ctx) => NewExpense(onAddExpense: addExpense),
    );
  }

  void _removeItem(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });

    ScaffoldMessenger.of(context)
        .clearSnackBars(); // clearing the previous message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Expense deleted'),
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseIndex, expense);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    // if no expense, show this
    Widget mainContent =
        const Center(child: Text('No expenses found. Start adding some'));

    // if there is an expense, show this
    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        onRemoveExpense: _removeItem,
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Expensy'),
          actions: [
            IconButton(
              onPressed: _openAddExpenseOverlay,
              icon: const Icon(Icons.add),
            )
          ],
        ),
        body: width < 600
            ? Column(
                children: [
                  Chart(expenses: _registeredExpenses),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: mainContent,
                    ),
                  ),
                ],
              )
            : Row(
                children: [
                  Expanded(
                    child: Chart(expenses: _registeredExpenses),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: mainContent,
                    ),
                  ),
                ],
              ));
  }
}
