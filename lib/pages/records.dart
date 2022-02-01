import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:walley/utils/auth.dart';
import 'package:get/get.dart';
import 'package:walley/utils/constants.dart';
import 'package:walley/utils/globalVars.dart';

class Records extends StatefulWidget {
  const Records({Key? key}) : super(key: key);
  @override
  State<Records> createState() => _RecordsState();
}

class _RecordsState extends State<Records> {
  CustomUser customUser = Get.put(CustomUser());
  GlobalVars globalVars = Get.put(GlobalVars());
  bool isLoading = true;
  Stream<QuerySnapshot<Map<String, dynamic>>>? snapshot;
  initStream() {
    setState(() {
      snapshot = FirebaseFirestore.instance
          .collection('users')
          .doc(customUser.email)
          .collection('records')
          .snapshots();
    });
  }

  String? getIconForCategory(String category) {
    List<Map<String, String>> categories =
        globalVars.expenseCategories + globalVars.incomeCategories;
    for (Map<String, String> temp in categories) {
      if (temp['title'] == category) {
        return temp['icon'];
      }
    }
  }

  @override
  void initState() {
    super.initState();
    initStream();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? CircularProgressIndicator()
        : Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(customUser.email)
                        .collection('records')
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
                                    bottom: BorderSide(
                                      color: Colors.black12,
                                    ),
                                  ),
                                ),
                                child: ListTile(
                                  leading: Text(
                                    getIconForCategory(
                                        documentSnapshot['category'])!,
                                    style: TextStyle(
                                      fontSize: 22,
                                    ),
                                  ),
                                  onTap: () {},
                                  title: Text(
                                    documentSnapshot['category'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: black,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
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
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "${documentSnapshot['type'] == 'Expense' ? "-" : "+"} ₹${documentSnapshot['amount'].toString()}",
                                        style: TextStyle(
                                          color: documentSnapshot['type'] ==
                                                  'Expense'
                                              ? darkRed
                                              : darkGreen,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        documentSnapshot['date'],
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        return Text("Nothing here...");
                      }
                    },
                  ),
                ],
              ),
            ),
          );
  }
}
