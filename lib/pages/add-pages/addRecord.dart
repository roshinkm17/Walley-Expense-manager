import 'package:flutter/material.dart';
import 'package:flutter_simple_calculator/flutter_simple_calculator.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:get/get.dart';
import 'package:walley/pages/home.dart';
import 'package:walley/pages/records.dart';
import 'package:walley/utils/auth.dart';
import 'package:walley/utils/constants.dart';
import 'package:group_button/group_button.dart';
import 'package:walley/utils/globalVars.dart';
import 'package:walley/utils/models.dart';
import 'package:walley/utils/firestorehelper.dart';

class AddRecord extends StatefulWidget {
  const AddRecord({Key? key}) : super(key: key);

  @override
  _AddRecordState createState() => _AddRecordState();
}

class _AddRecordState extends State<AddRecord> {
  List<bool> transferType = [];
  List<String> accounts = [];
  CalcController calcController = CalcController();
  Record record = Record();
  final CustomUser customUser = Get.put(CustomUser());
  final GlobalVars globalVars = Get.put(GlobalVars());

  @override
  void initState() {
    setState(() {
      transferType = [true, false, false];
      record.date = DateTime.now().toString().split(" ")[0];
      var time = TimeOfDay.now();
      record.time = "${time.hour}:${time.minute}";
      record.account = globalVars.accounts[0].name;
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
                children: [
                  GroupButton(
                    buttonHeight: 50,
                    buttonWidth: MediaQuery.of(context).size.width / 3.5,
                    unselectedTextStyle: TextStyle(
                      color: black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    selectedTextStyle: TextStyle(
                      color: black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    borderRadius: BorderRadius.circular(3),
                    selectedButton: 1,
                    selectedColor: Color(0xff96CEB4),
                    isRadio: true,
                    selectedShadow: [],
                    unselectedShadow: [],
                    mainGroupAlignment: MainGroupAlignment.center,
                    spacing: 5,
                    groupingType: GroupingType.row,
                    onSelected: (index, isSelected) {
                      setState(() {
                        if (index == 0) {
                          record.category = 'Income';
                          record.type = 'Income';
                        } else if (index == 1) {
                          record.category = 'Food';
                          record.type = 'Expense';
                        } else {
                          record.type = 'Transfer';
                        }
                      });
                    },
                    buttons: ["Income", "Expense", "Transfer"],
                  ),
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
                              value: record.account,
                              isExpanded: true,
                              borderRadius: BorderRadius.circular(3),
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: black,
                              ),
                              items: globalVars.accounts.map((Account account) {
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
                                record.account = newValue!;
                                setState(() {
                                  record.account = newValue;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: IconButton(
                          onPressed: () {},
                          color: black,
                          icon: Icon(Icons.location_on_outlined),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                        "5884, Jogiwara, Gali Mandir Wali, Nai Sarak, Delhi"),
                  ),
                  SizedBox(height: 10),
                  CategoryDropdown(context),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextFormField(
                      minLines: 6,
                      decoration: InputDecoration(
                        hintText: "Make a note of it",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: lightBlack),
                        ),
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      onChanged: (value) {
                        record.note = value;
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: TextButton.icon(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                Color(0xff96CEB4),
                              ),
                              padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
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
                                String date = res.toString().split(" ")[0];
                                setState(() {
                                  record.date = date;
                                  record.timestamp = res.toUtc();
                                });
                              }
                            },
                            icon: Icon(Icons.calendar_today_outlined,
                                color: black),
                            label: Text(
                              record.date,
                              style: TextStyle(
                                color: black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextButton.icon(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                Color(0xff96CEB4),
                              ),
                              padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                              ),
                            ),
                            onPressed: () async {
                              var res = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (res != null) {
                                String time = "${res.hour}:${res.minute}";
                                setState(() {
                                  record.time = time;
                                });
                              }
                            },
                            icon: Icon(Icons.access_time, color: black),
                            label: Text(
                              record.time,
                              style: TextStyle(
                                color: black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
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
                              horizontal: 20, vertical: 15),
                        ),
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  child: SimpleCalculator(
                                    onChanged: (key, value, expression) {
                                      setState(() {
                                        record.amount = calcController.value!;
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
                                        fontFamily: 'Sora',
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
                              "${record.amount}",
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
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ElevatedButton(
                  onPressed: () async {
                    if (record.amount == 0.0) {
                      showSnackBar("Attention", "Amount cannot be 0");
                      return;
                    }
                    final res =
                        await addRecordToFirebase(customUser.email, record);
                    if (res is String) {
                      showSnackBar('Error', res);
                      return;
                    }
                    Get.to(HomePage());
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

  Widget CategoryDropdown(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            border: Border.all(color: lightBlack),
            borderRadius: BorderRadius.circular(3),
          ),
          child: record.type == 'Expense'
              ? DropdownButton(
                  value: record.category,
                  isExpanded: true,
                  onChanged: (String? newValue) {
                    record.category = newValue!;
                    setState(() {
                      record.category = newValue;
                    });
                  },
                  items: globalVars.expenseCategories.map((category) {
                    return DropdownMenuItem(
                      value: category['title'],
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            category['icon']!,
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            category['title']!,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: black,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                )
              : DropdownButton(
                  value: record.category,
                  isExpanded: true,
                  onChanged: (String? newValue) {
                    record.category = newValue!;
                    setState(() {
                      record.category = newValue;
                    });
                  },
                  items: globalVars.incomeCategories.map((category) {
                    return DropdownMenuItem(
                      value: category['title'],
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            category['icon']!,
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            category['title']!,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: black,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                )),
    );
  }
}
