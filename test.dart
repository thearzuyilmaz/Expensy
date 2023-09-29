void main() {
  int maxNumber = 5;

  List<int> numbers = [
    for (int i = 1; i <= maxNumber; i++)
      if (i % 2 == 0) i * i else i * i * i,
  ];

  // Print the list
  print('Numbers: $numbers');
}

// Numbers: [1, 4, 27, 16, 125]
