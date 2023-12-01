import 'dart:async';
import 'package:flutter/material.dart';
import 'google_sheet_api.dart';
import 'loading_circle.dart';
import 'plus_button.dart';
import 'top_card.dart';
import 'transaction.dart';

class trackerPage extends StatefulWidget {
  const trackerPage({Key? key}) : super(key: key);

  @override
  _trackerPageState createState() => _trackerPageState();
}

class _trackerPageState extends State<trackerPage> {
  // collect user input
  final _textcontrollerAMOUNT = TextEditingController();
  final _textcontrollerITEM = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isIncome = false;
  GoogleSheetsApi googleSheetsApi = GoogleSheetsApi();
  List<List<dynamic>> currentTransactions = [];

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    await googleSheetsApi.init(); // Use the instance to call init
    setState(() {
      currentTransactions = GoogleSheetsApi.currentTransactions;
    });
  }

  // enter the new transaction into the spreadsheet
  void _enterTransaction() async{
    // Get the current date and time
    DateTime now = DateTime.now();
    String dateTime = now.toString();

    GoogleSheetsApi.insert(
      _textcontrollerITEM.text,
      _textcontrollerAMOUNT.text,
      _isIncome,
      dateTime, // Pass the dateTime to your insert function
    );

    _loadTransactions();

  }


  // new transaction
  void _newTransaction() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return AlertDialog(
                title: const Text('N E W  T R A N S A C T I O N'),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text('Expense'),
                          Switch(
                            value: _isIncome,
                            onChanged: (newValue) {
                              setState(() {
                                _isIncome = newValue;
                              });
                            },
                          ),
                          const Text('Income'),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Form(
                              key: _formKey,
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Amount?',
                                ),
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return 'Enter an amount';
                                  }
                                  return null;
                                },
                                controller: _textcontrollerAMOUNT,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'For what?',
                              ),
                              controller: _textcontrollerITEM,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  MaterialButton(
                    color: Colors.grey[600],
                    child:
                    const Text('Cancel', style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  MaterialButton(
                    color: Colors.grey[600],
                    child: const Text('Enter', style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _enterTransaction();
                        Navigator.of(context).pop();
                      }
                    },
                  )
                ],
              );
            },
          );
        });
  }

  // wait for the data to be fetched from google sheets
  bool timerHasStarted = false;
  void startLoading() {
    timerHasStarted = true;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (GoogleSheetsApi.loading == false) {
        setState(() {});
        timer.cancel();
      }
    });
  }

  // delete a transaction
  void _deleteTransaction(int index) {
    GoogleSheetsApi.delete(index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // start loading until the data arrives
    if (GoogleSheetsApi.loading == true && timerHasStarted == false) {
      startLoading();
    }

    return Scaffold(

      body: Container(
        color: const Color(0xFF04102A).withOpacity(0.9),//Colors.grey[300],,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 10.0),
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              TopNeuCard(
                balance: (GoogleSheetsApi.calculateIncome() -
                    GoogleSheetsApi.calculateExpense())
                    .toString(),
                income: GoogleSheetsApi.calculateIncome().toString(),
                expense: GoogleSheetsApi.calculateExpense().toString(),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: GoogleSheetsApi.loading == true
                            ? const LoadingCircle()
                            : ListView.builder(
                            itemCount:
                            GoogleSheetsApi.currentTransactions.length,
                            itemBuilder: (context, index) {
                              return Dismissible(
                                  key: UniqueKey(),
                              onDismissed: (direction) {
                              _deleteTransaction(index);
                              },
                              background: Container(
                              color: Colors.red,
                              alignment: AlignmentDirectional.centerEnd,
                              child: const Icon(
                              Icons.delete,
                              color: Color(0xFF213A71),
                              ),
                              ),
                                child: MyTransaction(
                                  transactionName: currentTransactions[index]
                                      .isNotEmpty
                                      ? currentTransactions[index][0]
                                      : 'N/A',
                                  money: currentTransactions[index]
                                      .isNotEmpty
                                      ? currentTransactions[index][1]
                                      : 'N/A',
                                  expenseOrIncome: currentTransactions[index]
                                      .isNotEmpty
                                      ? currentTransactions[index][2]
                                      : 'N/A',
                                  dateTime: currentTransactions[index]
                                      .length >
                                      3
                                      ? currentTransactions[index][3]
                                      : 'N/A',
                                  onDelete: () {
                                    _deleteTransaction(index);
                                },
                              ),


                              );
                            },
                        ),
                      )
                    ],
                  ),
                ),
              ),
              PlusButton(
                function: _newTransaction,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
