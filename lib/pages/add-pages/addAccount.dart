import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_simple_calculator/flutter_simple_calculator.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:get/get.dart';
import 'package:group_button/group_button.dart';
import 'package:walley/utils/auth.dart';
import 'package:walley/utils/constants.dart';
import 'package:walley/utils/models.dart';
import 'package:walley/utils/firestorehelper.dart';

class AddAccounts extends StatefulWidget {
  const AddAccounts({Key? key}) : super(key: key);

  @override
  _AddAccountsState createState() => _AddAccountsState();
}

class _AddAccountsState extends State<AddAccounts> {
  List<bool> transferType = [];
  String period = "Monthly";
  List<String> periods = [
    "Monthly",
    "Yearly",
  ];
  String category = 'Food and beverages';
  List<String> categories = [
    'Food and beverages',
    'Transport',
    'Welness',
    'Beauty',
    'Groceries',
    'Cloths',
    'Shopping',
    'Trip',
    'Electronics'
  ];
  CalcController calcController = CalcController();
  Account account = Account();
  final CustomUser customUser = Get.put(CustomUser());
  @override
  void initState() {
    setState(() {
      transferType = [true, false, false];
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: lightYellow,
        elevation: 0,
        iconTheme: IconThemeData(color: black),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "A new account",
                        labelText: "Account name",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: lightBlack),
                        ),
                      ),
                      keyboardType: TextInputType.name,
                      maxLines: null,
                      onChanged: (value) {
                        account.name = value;
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 50,
                    color: Colors.white,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            GroupButton(
                              buttons: accountEmojis,
                              selectedButton: 2,
                              selectedColor: Colors.white,
                              borderRadius: BorderRadius.circular(40),
                              selectedBorderColor: darkYellow,
                              selectedTextStyle: TextStyle(fontSize: 22),
                              groupingType: GroupingType.row,
                              direction: Axis.horizontal,
                              unselectedBorderColor: Colors.black12,
                              unselectedTextStyle: TextStyle(fontSize: 22),
                              onSelected: (index, isSelected) {
                                setState(() {
                                  account.icon = accountEmojis[index];
                                });
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text("Intial amount"),
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3),
                          side: BorderSide(color: lightBlack),
                        ),
                        elevation: 0,
                        primary: lightYellow,
                        textStyle: TextStyle(
                          color: black,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                child: SimpleCalculator(
                                  onChanged: (key, value, expression) {
                                    setState(() {
                                      account.inital = value!;
                                    });
                                  },
                                  theme: const CalculatorThemeData(
                                    displayColor: Colors.white,
                                    commandColor: lightYellow,
                                    operatorColor: lightYellow,
                                    numStyle: TextStyle(
                                      fontSize: 20,
                                      color: black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    commandStyle: TextStyle(
                                        color: black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                    operatorStyle:
                                        TextStyle(color: black, fontSize: 24),
                                    displayStyle: const TextStyle(
                                        fontSize: 100,
                                        color: black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              );
                            });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            FontAwesome5.rupee_sign,
                            color: black,
                            size: 20,
                          ),
                          SizedBox(width: 20),
                          Text(
                            "${account.inital.toString()}",
                            style: TextStyle(
                              color: black,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextFormField(
                      minLines: 3,
                      decoration: InputDecoration(
                        hintText: "Make a note of it",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: lightBlack),
                        ),
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      onChanged: (value) {
                        account.note = value;
                      },
                    ),
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Exclude from Stats",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: account.excludeFromStats
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        Switch(
                          value: account.excludeFromStats,
                          onChanged: (value) {
                            setState(() {
                              account.excludeFromStats = value;
                            });
                          },
                          activeColor: darkYellow,
                          inactiveThumbColor: lightBlack,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ElevatedButton(
                  onPressed: () async {
                    final res =
                        await addAccountToFirebase(customUser.email, account);
                    if (res is String) {
                      showSnackBar('Error', res);
                      return;
                    }
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: darkGreen,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "Save",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 3,
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(50),
                          ),
                        ),
                      ),
                      Icon(Icons.check_circle),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
