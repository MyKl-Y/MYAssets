// client/lib/screens/home_screen.dart

/*
UI Screen: Home Screen
*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/data_provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController transactionYearController = TextEditingController();
  final TextEditingController transactionMonthController = TextEditingController();
  final TextEditingController accountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<DataProvider>().fetchUser());
    Future.microtask(() => context.read<DataProvider>().fetchAccounts());
    Future.microtask(() => context.read<DataProvider>().fetchTransactions());
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<DataProvider>().user;
    final accounts = context.watch<DataProvider>().accounts;
    final transactions = context.watch<DataProvider>().transactions;

    List<String> getTransactionYears() {
      Set<String> temp = {'All'};
      List<String> returnList = [];

      for (var transaction in transactions) {
        temp.add(transaction['timestamp'].toString().split('-')[0]);
      }

      returnList = temp.toList();

      returnList.sort((b, a) => (a).compareTo(b));

      return returnList;
    }

    List<String> getTransactionMonths(String year) {
      Set<String> temp = {'All'};
      List<String> returnList = [];

      for (var transaction in transactions) {
        if ((transaction['timestamp'].toString().split('-')[0] == year) || year == 'All') {
          temp.add(transaction['timestamp'].toString().split('-')[1]);
        }
      }

      returnList = temp.toList();

      returnList.sort((b, a) => (a).compareTo(b));

      return returnList;
    }

    double totalBalance() {
      double balance = 0;

      for (var account in accounts) {
        balance += account['balance'];
      }

      return balance;
    }

    final transactionYears = getTransactionYears();

    //final transactionMonths = getTransactionMonths(transactionYears[0]);

    final accountNames = ['All', ...context.watch<DataProvider>().accountNames];

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      //appBar: AppBar(title: Text('Hi, ${user['username']}')),
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 4,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Hi, ${user['username']}', 
                    style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20))
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).size.height / 8 + 20, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Transactions', 
                          style: TextStyle(
                            fontSize: Theme.of(context).textTheme.titleLarge!.fontSize,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            spacing: 10,
                            children: [
                              DropdownMenu<String>(
                                label: Text('Year'),
                                controller: transactionYearController,
                                initialSelection: transactionYears[0],
                                dropdownMenuEntries: transactionYears.map((String year) {
                                  return DropdownMenuEntry<String>(value: year, label: year);
                                }).toList(),
                                onSelected: (String? value) {
                                  setState(() {
                                    
                                  });
                                },
                              ),
                              DropdownMenu<String>(
                                label: Text('Month'),
                                controller: transactionMonthController,
                                initialSelection: 'All',
                                dropdownMenuEntries: getTransactionMonths(transactionYearController.text).map((String month) {
                                  return DropdownMenuEntry<String>(value: month, label: month);
                                }).toList(),
                                onSelected: (String? value) {
                                  setState(() {
                                    
                                  });
                                },
                              ),
                              DropdownMenu<String>(
                                label: Text('Account'),
                                controller: accountController,
                                initialSelection: 'All',
                                dropdownMenuEntries: accountNames.map((String name) {
                                  return DropdownMenuEntry<String>(value: name, label: name);
                                }).toList(),
                                onSelected: (String? value) {
                                  setState(() {
                                    
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          //height: (MediaQuery.of(context).size.height * (5 / 8)) - 40,
                          child: ListView.builder(
                            itemCount: transactions.length,
                            itemBuilder: (context, index) {
                              transactions.sort((b, a) => a['timestamp'].compareTo(b['timestamp']));
                              final transaction = transactions[index];

                              if (
                                (
                                  transactionYearController.text == 'All' 
                                  && transactionMonthController.text == 'All'
                                  && accountController.text == 'All'
                                )
                                || (
                                  transaction['timestamp'].toString().split('-')[1] == transactionMonthController.text
                                  && transactionYearController.text == 'All' 
                                  && accountController.text == 'All'
                                )
                                || (
                                    transaction['timestamp'].toString().split('-')[0] == transactionYearController.text
                                    && transactionMonthController.text == 'All'
                                    && accountController.text == 'All'
                                ) 
                                || (
                                    transaction['timestamp'].toString().split('-')[0] == transactionYearController.text
                                    && transaction['timestamp'].toString().split('-')[1] == transactionMonthController.text
                                    && accountController.text == 'All'
                                ) 
                                || (
                                  transactionYearController.text == 'All' 
                                  && transactionMonthController.text == 'All'
                                  && transaction['account'] == accountController.text
                                )
                                || (
                                  transaction['timestamp'].toString().split('-')[1] == transactionMonthController.text
                                  && transactionYearController.text == 'All' 
                                  && transaction['account'] == accountController.text
                                )
                                || (
                                    transaction['timestamp'].toString().split('-')[0] == transactionYearController.text
                                    && transactionMonthController.text == 'All'
                                    && transaction['account'] == accountController.text
                                ) 
                                || (
                                    transaction['timestamp'].toString().split('-')[0] == transactionYearController.text
                                    && transaction['timestamp'].toString().split('-')[1] == transactionMonthController.text
                                    && transaction['account'] == accountController.text
                                )
                              ) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child:  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container( 
                                            margin: EdgeInsets.only(right: 20),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(180),
                                              color: transaction['type'] == 'Income' 
                                                ? const Color.fromARGB(75, 0, 255, 0) 
                                                : const Color.fromARGB(75, 255, 0, 0),
                                            ),
                                            child: Icon(
                                              transaction['type'] == 'Income' 
                                                ? Icons.add 
                                                : Icons.remove,
                                              color: transaction['type'] == 'Income' 
                                                ? Colors.green 
                                                : Colors.red,
                                              size: 35,
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${transaction['account']}: ${transaction['description']}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize
                                                ),
                                              ),
                                              Text(
                                                transaction['timestamp'],
                                                style: TextStyle(
                                                  fontSize: Theme.of(context).textTheme.bodySmall!.fontSize
                                                ),  
                                              ),
                                            ],
                                          ),
                                        ]
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            transaction['type'] == 'Income' ? '+' : '-',
                                            style: TextStyle(
                                              fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                                              fontWeight: FontWeight.bold,
                                              color: transaction['type'] == 'Income' 
                                                ? Colors.green
                                                : Colors.red,
                                            ),
                                          ),
                                          Text(
                                            ' \$ ${(transaction['amount'] as double).toStringAsFixed(2)}',
                                            style: TextStyle(
                                              fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                                              fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        ]
                                      ),
                                    ],
                                  )
                                );
                              } else {
                                return Container();
                              }
                            }
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned.fill(
            top: MediaQuery.of(context).size.height / 8,
            child: Align(
              alignment: Alignment.topCenter,
              child:Container(
                height: MediaQuery.of(context).size.height / 4,
                width: MediaQuery.of(context).size.height / 2,
                decoration: BoxDecoration(
                  //color: Theme.of(context).colorScheme.primary,
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary, 
                      Theme.of(context).colorScheme.inversePrimary,
                      Theme.of(context).colorScheme.secondary
                    ],
                    stops: [0, .6, 1],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    tileMode: TileMode.clamp,
                  ),
                  borderRadius: BorderRadius.circular(20)
                ),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Balance',
                        style: TextStyle(
                          fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                      Text(
                        '\$ ${totalBalance().toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: Theme.of(context).textTheme.displaySmall!.fontSize,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                      Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Accounts: ${accounts.length}',
                            style: TextStyle(
                              fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                          Icon(
                            Icons.code,
                            //Icons.api,
                            color: Theme.of(context).colorScheme.onPrimary,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ),
          ),
        ],
      ),
    );
  }
}
