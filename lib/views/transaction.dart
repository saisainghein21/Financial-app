import 'package:flutter/material.dart';

class MyTransaction extends StatelessWidget {
  final String transactionName;
  final String money;
  final String expenseOrIncome;
  final VoidCallback onDelete;

  MyTransaction({super.key,
    required this.transactionName,
    required this.money,
    required this.expenseOrIncome,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0.0),
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
                    // decoration: BoxDecoration(
                    //     shape: BoxShape.circle, color: Colors.grey[500]),
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
                  Text(transactionName,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      )),
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