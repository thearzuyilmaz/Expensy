import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io'; //for platform.isOS
import 'package:expense_tracker/models/expense.dart'; // to call the Date formatter

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  // TextEditingController() stores input values
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

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
      _selectedDate = pickedDate;
    });
  }

  void _showDialog() {
    if (Platform.isIOS) {
      showCupertinoDialog(
          context: context,
          builder: (ctx) => CupertinoAlertDialog(
                title: const Text('Invalid input'),
                content: const Text('Please make sure to enter valid input'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                    },
                    child: const Text('Okay'),
                  ),
                ],
              ));
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid input'),
          content: const Text('Please make sure to enter valid input'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
    }
  }

  void _submitExpenseData() {
    // data verification
    final enteredAmount = double.tryParse(_amountController.text);
    // no need to check the category as it has a default value
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      _showDialog();
    }

    widget.onAddExpense(
      Expense(
          date: _selectedDate!,
          amount: enteredAmount ??
              0, // Provide a default value of 0.0 if enteredAmount is null.
          title: _titleController.text,
          category: _selectedCategory),
    );
    Navigator.pop(context);
  }

  // We should dispose the controller
  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _amountController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(builder: (ctx, constraints) {
      final width = constraints.maxWidth; //layout is based width
      return SizedBox(
        height: double.infinity, // Elongate modal sheet
        child: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.fromLTRB(24, 16, 24, keyboardSpace + 16),
              child: Column(
                children: [
                  if (width >= 600)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _titleController,
                            maxLength: 50, //instead of onChanged
                            decoration: const InputDecoration(
                              prefixText:
                                  ' ', // hizalamak için koydum alttaki $ amount kısmını kaydırıyordu
                              label: Text('Title'),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 32.0,
                        ),
                        Expanded(
                          child: TextField(
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              prefixText: '\$ ',
                              label: Text('Amount'),
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    TextField(
                      controller: _titleController, //instead of onChanged
                      maxLength: 50,
                      decoration: const InputDecoration(
                        label: Text('Title'),
                      ),
                    ),
                  const SizedBox(
                    height: 32.0,
                  ),
                  if (width >= 600)
                    Row(
                      children: [
                        DropdownButton(
                            value: _selectedCategory,
                            items: Category.values
                                .map(
                                  (item) => DropdownMenuItem<Category>(
                                    // You should ensure that the value of each DropdownMenuItem
                                    // corresponds to a value from the Category enum.
                                    value: item,
                                    child: Text(item.name.toUpperCase()),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              if (value == null) {
                                return; // after return no code works, hence value null check is done
                              }
                              setState(() {
                                _selectedCategory =
                                    value; // value can be null if user does not select anything, so needs a if check
                              });
                            }),
                        Expanded(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              _selectedDate == null
                                  ? 'No date selected'
                                  : formatter.format(_selectedDate!),
                            ),
                            IconButton(
                              onPressed: _presentDatePicker,
                              icon: const Icon(Icons.calendar_month),
                            ),
                          ],
                        )),
                      ],
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              prefixText: '\$ ',
                              label: Text('Amount'),
                            ),
                          ),
                        ),
                        Expanded(
                            child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.end, // push to the right
                          children: [
                            Text(
                              _selectedDate == null
                                  ? 'No date selected'
                                  : formatter.format(_selectedDate!),
                            ),
                            IconButton(
                              onPressed: _presentDatePicker,
                              icon: const Icon(Icons.calendar_month),
                            ),
                          ],
                        )),
                      ],
                    ),
                  const SizedBox(
                    height: 32.0,
                  ),
                  if (width >= 600)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _submitExpenseData(); // or onPressed: _submitExpenseData,
                          },
                          child: const Text('Add Expense'),
                        )
                      ],
                    )
                  else
                    // Category.values give a list of enum values
                    Row(
                      children: [
                        DropdownButton(
                            value: _selectedCategory,
                            items: Category.values
                                .map(
                                  (item) => DropdownMenuItem<Category>(
                                    // You should ensure that the value of each DropdownMenuItem
                                    // corresponds to a value from the Category enum.
                                    value: item,
                                    child: Text(item.name.toUpperCase()),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              if (value == null) {
                                return; // after return no code works, hence value null check is done
                              }
                              setState(() {
                                _selectedCategory =
                                    value; // value can be null if user does not select anything, so needs a if check
                              });
                            }),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _submitExpenseData(); // or onPressed: _submitExpenseData,
                          },
                          child: const Text('Add Expense'),
                        ),
                      ],
                    )
                ],
              )),
        ),
      );
    });
  }
}
