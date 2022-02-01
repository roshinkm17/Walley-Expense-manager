import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/iconic_icons.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:walley/pages/accounts.dart';
import 'package:walley/pages/add-pages/addAccount.dart';
import 'package:walley/pages/add-pages/addBudget.dart';
import 'package:walley/pages/add-pages/addGoals.dart';
import 'package:walley/pages/budgets.dart';
import 'package:walley/pages/goals.dart';
import 'package:walley/pages/records.dart';
import 'package:walley/utils/auth.dart';
import 'package:walley/utils/constants.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:walley/utils/firestorehelper.dart';
import 'package:walley/utils/globalVars.dart';
import 'package:walley/utils/models.dart';

import 'add-pages/addRecord.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CustomUser customUser = Get.put(CustomUser());
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  DateTime selDate = DateTime.now();
  String selMonth = '';
  String selYear = '';
  int selectedIndex = 0;
  List<Widget> pages = [
    Records(key: PageStorageKey('records')),
    Budgets(key: PageStorageKey('budgets')),
    Goals(key: PageStorageKey('goals')),
    Accounts(key: PageStorageKey('accounts')),
  ];
  final PageStorageBucket bucket = PageStorageBucket();
  GlobalVars globalVars = Get.put(GlobalVars());
  double income = 0;
  double expense = 0;
  double balance = 0;
  getAccounts() async {
    var snapshot = await getAccountsFromFirebase(customUser.email);
    if (snapshot is String) {
      showSnackBar('Error getting accounts', snapshot.toString());
      return;
    }
    List<DocumentSnapshot> docs = snapshot.docs;
    globalVars.removeAllAccounts();
    docs.forEach((doc) {
      setState(() {
        if (doc.data() != null) {
          var data = doc.data() as dynamic;
          Account account = new Account();
          account.name = data['name'];
          account.inital = data['initial'];
          account.current = data['current'] / 1.0;
          account.note = data['note'];
          account.excludeFromStats = data['excludeFromStats'];
          account.timestamp = data['timestamp'].toDate();
          account.expense = data['expense'];
          account.income = data['income'];
          account.icon = data['icon'];
          globalVars.setAccount(account);
        }
      });
    });
    await getGeneralStats();
  }

  getGeneralStats() {
    balance = 0;
    expense = 0;
    income = 0;
    globalVars.accounts.forEach((account) {
      if (!account.excludeFromStats) {
        balance += account.current;
        expense += account.expense;
        income += account.income;
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      selMonth = months[DateTime.now().month - 1];
      selYear = DateTime.now().year.toString();
    });
    getAccounts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(child: Center(child: Text("Drawer still to be done"))),
      appBar: AppBar(
        centerTitle: true,
        // title: Container(
        //   height: 50,
        //   child: DropdownButton(
        //     borderRadius: BorderRadius.circular(3),
        //     value: selectedAccount,
        //     icon: const Icon(
        //       Icons.arrow_drop_down,
        //       color: black,
        //     ),
        //     items: globalVars.accounts.map((Account account) {
        //       return DropdownMenuItem(
        //         value: account.name,
        //         child: Row(
        //           children: [
        //             Icon(
        //               Icons.eighteen_mp,
        //               color: black,
        //             ),
        //             SizedBox(width: 10),
        //             Text(account.name),
        //           ],
        //         ),
        //       );
        //     }).toList(),
        //     onChanged: (String? newValue) {
        //       setState(() {
        //         selectedAccount = newValue!;
        //       });
        //     },
        //   ),
        // ),
        leading: IconButton(
          icon: Icon(Icons.menu, color: black),
          onPressed: () => _scaffoldKey.currentState!.openDrawer(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: CircleAvatar(
              child: Icon(Icons.supervised_user_circle, color: black),
              backgroundColor: lightYellow,
            ),
          )
        ],
        backgroundColor: lightYellow,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'main-btn',
        onPressed: () {
          if (selectedIndex == 0) {
            Get.to(AddRecord());
          } else if (selectedIndex == 1) {
            Get.to(AddBudget());
          } else if (selectedIndex == 2) {
            Get.to(AddGoals());
          } else {
            Get.to(AddAccounts());
          }
        },
        child: Icon(Icons.add),
        backgroundColor: darkRed,
      ),
      bottomNavigationBar: GNav(
        selectedIndex: selectedIndex,
        onTabChange: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        backgroundColor: lightYellow,
        textStyle: TextStyle(
            fontSize: 14, fontWeight: FontWeight.bold, color: darkYellow),
        padding: EdgeInsets.all(20),
        gap: 10,
        color: darkYellow,
        activeColor: darkYellow,
        iconSize: 18,
        rippleColor: Colors.black12,
        tabs: [
          GButton(
            icon: Iconic.article,
            text: "Records",
            iconColor: black,
          ),
          GButton(
            icon: FontAwesome5.money_bill,
            text: "Budgets",
            iconColor: black,
          ),
          GButton(
            icon: FontAwesome5.piggy_bank,
            text: "Goals",
            iconColor: black,
          ),
          GButton(
            icon: Icons.account_balance_wallet,
            text: "Accounts",
            iconColor: black,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            FiltersTab(context),
            PageStorage(bucket: bucket, child: pages[selectedIndex]),
          ],
        ),
      ),
    );
  }

  Widget FiltersTab(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: lightYellow,
        border: Border(
          bottom: BorderSide(color: Colors.white),
        ),
      ),
      height: 100,
      child: Column(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Income"),
                    SizedBox(height: 5),
                    Text(
                      "₹" + income.toString(),
                      style: TextStyle(
                        color: darkGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text("Expense"),
                    SizedBox(height: 5),
                    Text(
                      "₹${expense}",
                      style: TextStyle(
                        color: darkRed,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text("Balance"),
                    SizedBox(height: 5),
                    Text(
                      "₹${balance}",
                      style: TextStyle(
                        color: darkGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () async {
                    final selected = await showMonthYearPicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2019),
                      lastDate: DateTime(2023),
                    );
                    if (selected != null && selected != DateTime.now()) {
                      setState(() {
                        selDate = selected;
                        selMonth = months[selected.month - 1];
                        selYear = selected.year.toString();
                      });
                    }
                  },
                  child: Text(
                    "${selMonth} ${selYear}",
                    style: TextStyle(color: black, fontWeight: FontWeight.bold),
                  ),
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   children: [
                //     IconButton(
                //       onPressed: () {
                //         //filter options
                //       },
                //       icon: Icon(
                //         Icons.filter_alt_outlined,
                //         color: black,
                //       ),
                //     ),
                //     IconButton(
                //       onPressed: () {
                //         //search option
                //       },
                //       icon: Icon(
                //         Icons.search_outlined,
                //         color: black,
                //       ),
                //     )
                //   ],
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
