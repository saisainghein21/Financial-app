import 'package:flutter/material.dart';

class MyTransaction extends StatelessWidget {
  final String transactionName;
  final String money;
  final String expenseOrIncome;
  final String dateTime; // Add this line
  final VoidCallback onDelete;

  MyTransaction({
    super.key,
    required this.transactionName,
    required this.money,
    required this.expenseOrIncome,
    required this.dateTime, // Add this line
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(15),
          color: const Color(0xFF213A71),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    child: const Center(
                      child: Icon(
                        Icons.attach_money_outlined,
                        color: Colors.yellow,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column( // Wrap the text in a column to display both name and date/time
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transactionName,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        dateTime, // Display date and time
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    (expenseOrIncome == 'expense' ? '-' : '+') + '\$' + money,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: expenseOrIncome == 'expense'
                          ? Colors.red
                          : Colors.green,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: onDelete,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
