import 'dart:async';

import 'package:ext/googlesheets_api.dart';
import 'package:ext/plus_button.dart';
import 'package:ext/top_card.dart';
import 'package:ext/transactions.dart';
import 'package:flutter/material.dart';

import 'loadingCircle.dart';

class HomePage extends StatefulWidget {

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // collect user input
  final _textcontrollerAMOUNT = TextEditingController();
  final _textcontrollerITEM = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isIncome = false;

 // enter the new transaction into the spreadsheet
  void _enterTransaction() {
    GooglesheetsApi.insert(
      _textcontrollerITEM.text,
      _textcontrollerAMOUNT.text,
      _isIncome,
    );
    setState(() {});
  }


  void _newTransaction() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return AlertDialog(
                title: Text(' Xisaab Cusub'),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('Qarash'),
                          Switch(
                            value: _isIncome,
                            onChanged: (newValue) {
                              setState(() {
                                _isIncome = newValue;
                              });
                            },
                          ),
                          Text('Dhaqaale'),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Form(
                              key: _formKey,
                              child: TextFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Tirada?',
                                ),
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return 'Gali Tirada';
                                  }
                                  return null;
                                },
                                controller: _textcontrollerAMOUNT,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
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
                        Text('Ka Laabo', style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  MaterialButton(
                    color: Colors.grey[600],
                    child: Text('Gal', style: TextStyle(color: Colors.white)),
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
      if (GooglesheetsApi.loading == false) {
        setState(() {});
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
       // start loading until the data arrives
    if (GooglesheetsApi.loading == true && timerHasStarted == false) {
      startLoading();
    }
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body:  Column(
        children: [
          TopNeuCard(
           balance: (GooglesheetsApi.calculateIncome() -
                      GooglesheetsApi.calculateExpense())
                  .toStringAsFixed(2),
         expense: GooglesheetsApi.calculateExpense().toString(),
         income: GooglesheetsApi.calculateIncome().toString(),
         ),
          Expanded(
            child: Container(
             // color: Colors.blue[300],
              child:   Center(child: Column(
                children: [
                  const SizedBox(height: 10,),
                Expanded(child: 
                GooglesheetsApi.loading == true ? const LoadingCircle() :
                ListView.builder(
                  itemCount: GooglesheetsApi.currentTransactions.length,
                  itemBuilder: ((context, index) {

               return   MyTransaction(
         
                                    transactionName: GooglesheetsApi
                                        .currentTransactions[index][0],
                                    money: GooglesheetsApi
                                        .currentTransactions[index][1],
                                    expenseOrIncome: GooglesheetsApi
                                        .currentTransactions[index][2],
                                  );
                }))
                ,)
                  
                ],
              )),
            ),
          ),
          PlusButton( function: _newTransaction, ),
        ],
      ),
    );
  }
}
