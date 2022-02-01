import 'package:flutter/material.dart';
import 'package:flutter_simple_calculator/flutter_simple_calculator.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:get/get.dart';
import 'package:walley/utils/auth.dart';
import 'package:walley/utils/constants.dart';
import 'package:walley/utils/models.dart';
import 'package:walley/utils/firestorehelper.dart';

class AddGoals extends StatefulWidget {
  const AddGoals({Key? key}) : super(key: key);

  @override
  _AddGoalsState createState() => _AddGoalsState();
}

class _AddGoalsState extends State<AddGoals> {
  List<bool> transferType = [];
  String account = 'Cash';
  List<String> accounts = [
    'Cash',
    'Bank Account 1',
    'Bank account 2',
    'Savings',
    'HDFC',
  ];
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
  Goal goal = Goal();
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
                        hintText: "A new goal",
                        labelText: "Goal name",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: lightBlack),
                        ),
                      ),
                      keyboardType: TextInputType.name,
                      maxLines: null,
                      onChanged: (value) {
                        goal.name = value;
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextButton.icon(
                        style: ButtonStyle(
                          alignment: Alignment.topLeft,
                          backgroundColor: MaterialStateProperty.all(
                            Color(0xff96CEB4),
                          ),
                          padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(horizontal: 20, vertical: 13),
                          ),
                        ),
                        onPressed: () async {
                          var res = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2021),
                            lastDate: DateTime(2023),
                          );
                          if (res != null) {
                            setState(() {
                              goal.date = res.toUtc();
                            });
                          }
                        },
                        icon: Icon(Icons.calendar_today_outlined, color: black),
                        label: Text(
                          "Date",
                          style: TextStyle(
                            color: black,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
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
                                      goal.initial = calcController.value!;
                                    });
                                  },
                                  controller: calcController,
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
                            "${goal.initial}",
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
                    child: Text("Target amount"),
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
                                      goal.target = value!;
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
                            "${goal.target}",
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
                        goal.note = value;
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ElevatedButton(
                  onPressed: () async {
                    if (goal.target == 0.0) {
                      showSnackBar("Attention", "Target amount cannot be 0");
                      return;
                    }
                    final res = await addGoalToFirebase(customUser.email, goal);
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
