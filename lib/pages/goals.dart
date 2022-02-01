import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:walley/utils/auth.dart';
import 'package:walley/utils/constants.dart';
import 'package:intl/intl.dart';

class Goals extends StatefulWidget {
  const Goals({Key? key}) : super(key: key);

  @override
  State<Goals> createState() => _GoalsState();
}

class _GoalsState extends State<Goals> {
  CustomUser customUser = Get.put(CustomUser());
  final formatCurrency = new NumberFormat.simpleCurrency();
  bool isLoading = false;
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
                        .collection('goals')
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
                                  title: Text(
                                    documentSnapshot['name'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: black,
                                    ),
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
                                      value: 0.3,
                                      color: darkGreen,
                                    ),
                                  ),
                                  trailing: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${formatCurrency.format(documentSnapshot['target'])}',
                                        style: TextStyle(
                                          color: darkGreen,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text("21 Days")
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
