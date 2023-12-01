import 'package:gsheets/gsheets.dart';

class GoogleSheetsApi {
  // create credentials
  static const _credentials = r'''
  {
  "type": "service_account",
  "project_id": "financial-b5f91",
  "private_key_id": "8f392d1b462a75567531fc749c00e5c3fb6f16be",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQDBo67O0i5ZAomH\nWz3ZxMQwl4agiSUTERC13nqPg0VgNxehHlhPwNPApbSVt6Vsok2CI6Ilm/MJEts6\nR47lLuHcH0L+xsVumjvVR3wovztG1lI9JSGOisIFvrnw/nQ9nW1I0wdy8j4RNazC\n9OdaW/RemHooYWe2jvvovwByM8hOEDSnXG1fHtQeIduhK7rcLP03rLNOHsSfjD6d\nNHt82/obF2fhDS24RNAQIftcT4mPdcufsbfuMv9s0f2bKKYQHJzQ/aI4wvBNpfGa\naTydRCTmUtZlWGIl1PBWYuxOZiROuLvc1giWHHkTVXMZg5e7wr2dXSOCTRxCe1CV\n+bUcE42nAgMBAAECggEACeoTC7TYOad3Gi6SQqGf9+ryMisDcm/3vpAXD10FwtDf\nTVkL5X12ehEh516BQkgnFsgzR6Ct92N3RQsf5l0ZpFcXa4sK1chg0uE3mrB73Psh\nN888Yht5pqimxY+JrRPv4gAoC/saMXBhmZPHeqlloChHbOTb1g2JGVgaMj6zfUeh\nSYhSe3DOiOfghrRbyhmdGsR03LrtgHVhAD/VBLDK9L5YRYzcxvthPl8jkmTkdeb1\n38hgqQ7dzwrrUWkj/dRO16h9e+Vvuqp46AjZNrzQ711z9bRKBfHLLvtQ9EZJrABT\n0C/DAlQwgOho/jmtV755Z/Gj+CYXUBVZ4UvCF6qYBQKBgQDtmd1nk1mYehIZ2NXn\nfHhCAHTnhpus8yp3N5ypllOebCuRY80lzpLY12Eo5UKQGv9iSgJDUi0zn3T/00WC\nmZxQB8fxsJNq/JH2wUMuserzZQ+1ShW/DoA9xTUHJLxpYEjle9oF4WFSYAXdJRI7\nEDVWKxwqkQqFKU+TroaMvDD6/QKBgQDQolW1hBwOTotRb3aOQYBhAjphTHfSVP9w\n1UKUosLTRO2D31BoqfDQSxKJLvT0DcdWPjTIAJMGIobPciz1iXmmPd+8LN6Qj+PB\n5S72L40//JkMV8ePRn5htsqksENPt9l6j0AMdus6c+sT51h8QuSOlzbLQlrHJj4W\nzcRNr/pmcwKBgG+mOdAOAbAQzKiwp/NbHfeF12lka4rdyTq0Oz3Fkg2DrwVm7GOz\nqnWS3+kjsh+dUByTwnR4DR2Q9J2yXZt9K2LABUihPOStQrm9HyC2Ij21Y6hA4+8f\nlUtxe/WbYZ3yzM5pYI4a1myrCpZccTCn8ShIobeu6E6ilu5CuJ8xX6LRAoGAdUDG\nqpz0p5W89qeOGaT2YY6/AK/ZJ3xdkyxHnwFaPSIf2l1G84uOq4GFiVO6lu6nePC8\n+SpZdrkwyqWAXv5EQAnGFBujedtkRTRokDNpTuzHlwg+P2d+36u7d5MYQVUyBI89\nj8PFr7Q2CZmbQTrW+MxDHzjLi+ESQ/6gtIiSUcECgYAX6O47DtuVQRvM89Z0qFRl\n+7JKr7EJeaolR1vxzEz54eSBs8clPf/e5+ZPzJHBTre6gxkGgUiNaPBobX9ETaUk\n+gCzDrejmLMjKRYQdSr7hlo6JO+5YkiFEIjdmmaaC8ECiXKXEWuUWczHqEIkVS+d\nFMWDbZB2gK74QdWKxae3jw==\n-----END PRIVATE KEY-----\n",
  "client_email": "financial@financial-b5f91.iam.gserviceaccount.com",
  "client_id": "100012903972787952018",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/financial%40financial-b5f91.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}

  ''';

  // set up & connect to the spreadsheet
  static final _spreadsheetId = '1iSwbcdzS-tpW7CfAVceAI8KJxgaQQZ9_5nXu8eWEHBs';
  static final _gsheets = GSheets(_credentials);
  static Worksheet? _worksheet;

  // some variables to keep track of..
  static int numberOfTransactions = 0;
  static List<List<dynamic>> currentTransactions = [];
  static bool loading = true;

  // initialise the spreadsheet!
  Future init() async {
    final ss = await _gsheets.spreadsheet(_spreadsheetId);
    _worksheet = ss.worksheetByTitle('Worksheet1');
    countRows();
  }

  // count the number of notes
  static Future countRows() async {
    while ((await _worksheet!.values
        .value(column: 1, row: numberOfTransactions + 1)) !=
        '') {
      numberOfTransactions++;
    }
    // now we know how many notes to load, now let's load them!
    loadTransactions();
  }

  // load existing notes from the spreadsheet
  static Future loadTransactions() async {
    if (_worksheet == null) return;

    for (int i = 1; i < numberOfTransactions; i++) {
      final String transactionName =
      await _worksheet!.values.value(column: 1, row: i + 1);
      final String transactionAmount =
      await _worksheet!.values.value(column: 2, row: i + 1);
      final String transactionType =
      await _worksheet!.values.value(column: 3, row: i + 1);

      if (currentTransactions.length < numberOfTransactions) {
        currentTransactions.add([
          transactionName,
          transactionAmount,
          transactionType,
        ]);
      }
    }
    print(currentTransactions);
    // this will stop the circular loading indicator
    loading = false;
  }

  // insert a new transaction
  static Future insert(String name, String amount, bool _isIncome, String dateTime) async {
    if (_worksheet == null) return;
    numberOfTransactions++;
    currentTransactions.add([
      name,
      amount,
      _isIncome == true ? 'income' : 'expense',
      dateTime, // Include the dateTime in the currentTransactions list
    ]);
    await _worksheet!.values.appendRow([
      name,
      amount,
      _isIncome == true ? 'income' : 'expense',
      dateTime, // Include the dateTime in the spreadsheet
    ]);
  }


  // CALCULATE THE TOTAL INCOME!
  static double calculateIncome() {
    double totalIncome = 0;
    for (int i = 0; i < currentTransactions.length; i++) {
      if (currentTransactions[i][2] == 'income') {
        totalIncome += double.parse(currentTransactions[i][1]);
      }
    }
    return totalIncome;
  }

  // CALCULATE THE TOTAL EXPENSE!
  static double calculateExpense() {
    double totalExpense = 0;
    for (int i = 0; i < currentTransactions.length; i++) {
      if (currentTransactions[i][2] == 'expense') {
        totalExpense += double.parse(currentTransactions[i][1]);
      }
    }
    return totalExpense;
  }

  // delete a transaction by index
  static Future<void> delete(int index) async {
    if (_worksheet == null) return;

    // Remove the transaction from the currentTransactions list
    if (index >= 0 && index < currentTransactions.length) {
      currentTransactions.removeAt(index);
      numberOfTransactions--;

      // Delete the row from the spreadsheet
      await _worksheet!.deleteRow(index + 2); // Adjust for 1-based index
    }
  }
}
