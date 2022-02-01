import 'package:flutter/material.dart';
import 'package:flutter_simple_calculator/flutter_simple_calculator.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:get/get.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:walley/utils/auth.dart';
import 'package:walley/utils/constants.dart';
import 'package:walley/utils/globalVars.dart';
import 'package:walley/utils/models.dart';
import 'package:walley/utils/firestorehelper.dart';

class AddBudget extends StatefulWidget {
  const AddBudget({Key? key}) : super(key: key);

  @override
  _AddBudgetState createState() => _AddBudgetState();
}

class _AddBudgetState extends State<AddBudget> {
  List<bool> transferType = [];
  GlobalVars globalVars = Get.put(GlobalVars());
  String period = "Monthly";
  List<String> periods = [
    "Monthly",
    "Yearly",
  ];
  CalcController calcController = CalcController();
  Budget budget = Budget();
  final CustomUser customUser = Get.put(CustomUser());

  setRemainingDays() {
    setState(() {
      if (budget.period == 'Monthly') {
        budget.remDays =
            DateTime(DateTime.now().year, (DateTime.now().month + 1) % 12, 0)
                    .day -
                DateTime.now().day;
        budget.totalDays =
            DateTime(DateTime.now().year, (DateTime.now().month + 1) % 12, 0)
                .day;
      } else {
        budget.remDays = DateTime.now()
                .difference(DateTime(DateTime.now().year + 1, 1, 1))
                .inDays *
            -1;
        budget.totalDays = DateTime(DateTime.now().year, 1, 1)
                .difference(DateTime(DateTime.now().year + 1, 1, 1))
                .inDays *
            -1;
      }
    });
  }

  @override
  void initState() {
    setState(() {
      budget.account = globalVars.accounts[0].name;
    });
    setRemainingDays();
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
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: Color(0xff96CEB4),
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: DropdownButton(
                                value: budget.account == ''
                                    ? globalVars.accounts[0].name
                                    : budget.account,
                                isExpanded: true,
                                borderRadius: BorderRadius.circular(3),
                                icon: const Icon(
                                  Icons.arrow_drop_down,
                                  color: black,
                                ),
                                items:
                                    globalVars.accounts.map((Account account) {
                                  return DropdownMenuItem(
                                    value: account.name,
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 7),
                                          child: CircleAvatar(
                                            backgroundColor: Colors.white,
                                            child: Text(
                                              account.icon,
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Text(account.name),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  budget.account = newValue!;
                                  setState(() {
                                    budget.account = newValue;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "My Food Plan",
                          labelText: "Budget name",
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: lightBlack),
                          ),
                        ),
                        keyboardType: TextInputType.name,
                        maxLines: null,
                        onChanged: (value) {
                          budget.name = value;
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Color(0xff96CEB4),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: DropdownButton(
                          value: budget.period,
                          isExpanded: true,
                          borderRadius: BorderRadius.circular(3),
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: black,
                          ),
                          items: periods.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Row(
                                children: [
                                  Icon(Icons.eighteen_mp),
                                  SizedBox(width: 10),
                                  Text(items),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              budget.period = newValue!;
                              setRemainingDays();
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Hero(
                        tag: 'main-btn',
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
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return Container(
                                    child: SimpleCalculator(
                                      onChanged: (key, value, expression) {
                                        setState(() {
                                          budget.amount = calcController.value!;
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
                                        operatorStyle: TextStyle(
                                            color: black, fontSize: 24),
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
                                "${budget.amount}",
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
                    ),
                    SizedBox(height: 10),
                    MultiSelect(context),
                    SizedBox(height: 20),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (budget.amount == 0.0) {
                        showSnackBar("Attention", "Amount cannot be 0");
                        return;
                      }
                      if (budget.categories.length == 0) {
                        showSnackBar('Attention',
                            'Select atleast one category in the budget');
                        return;
                      }
                      final res =
                          await addBudgetToFirebase(customUser.email, budget);
                      if (res is String) {
                        showSnackBar('Error', res);
                        return;
                      }
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: darkGreen,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
      ),
    );
  }

  Widget MultiSelect(context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: MultiSelectDialogField(
        items: globalVars.expenseCategories
            .map(
              (Map<String, String> category) => MultiSelectItem(
                  category, '${category['icon']} ${category['title']}'),
            )
            .toList(),
        searchable: true,
        backgroundColor: Colors.white,
        listType: MultiSelectListType.CHIP,
        buttonText: Text("Select categories to include"),
        buttonIcon: Icon(Icons.arrow_drop_down),
        selectedItemsTextStyle: TextStyle(color: black),
        chipDisplay: MultiSelectChipDisplay(
          height: 10,
          alignment: Alignment.topLeft,
          chipColor: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: lightBlack),
            borderRadius: BorderRadius.circular(10),
          ),
          scrollBar: HorizontalScrollBar(isAlwaysShown: true),
          textStyle: TextStyle(
            color: black,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        onConfirm: (List<dynamic> values) {
          setState(() {
            var temp = new List<Map<String, String>>.from(values);
            budget.categories = temp;
          });
        },
      ),
    );
  }
}
