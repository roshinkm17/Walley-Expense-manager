import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:walley/utils/auth.dart';
import 'package:walley/utils/constants.dart';
import 'package:intl/intl.dart';

class Budgets extends StatefulWidget {
  const Budgets({Key? key}) : super(key: key);

  @override
  State<Budgets> createState() => _BudgetsState();
}

class _BudgetsState extends State<Budgets> {
  CustomUser customUser = Get.put(CustomUser());
  final formatCurrency = new NumberFormat.simpleCurrency();
  bool isLoading = false;
  getValueCompleted(var amount, var spent) {
    double value = spent / amount;
    print(value);
    return value;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? CircularProgressIndicator()
        : Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(customUser.email)
                        .collection('budgets')
                        .orderBy('timestamp', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot documentSnapshot =
                                  snapshot.data!.docs[index];
                              return Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: Colors.black12),
                                  ),
                                ),
                                child: ListTile(
                                  leading: Icon(Icons.savings_outlined),
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        documentSnapshot['name'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: black,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 2),
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(3),
                                          color: Color(0xffF7D9D8),
                                        ),
                                        child: Text(
                                          documentSnapshot['account'],
                                          style: TextStyle(
                                            color: black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  subtitle: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: lightBlack),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                    margin: EdgeInsets.only(top: 7),
                                    child: LinearProgressIndicator(
                                      minHeight: 5,
                                      backgroundColor: lightYellow,
                                      value: getValueCompleted(
                                          documentSnapshot['amount'],
                                          documentSnapshot['spent']),
                                      color: darkGreen,
                                    ),
                                  ),
                                  trailing: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${formatCurrency.format(documentSnapshot['amount'])}',
                                        style: TextStyle(
                                          color: darkGreen,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        "${documentSnapshot['remDays'].toString()} days to go",
                                        style: TextStyle(
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }
                      return Text("Nothing here");
                    },
                  ),
                ],
              ),
            ),
          );
  }
}
