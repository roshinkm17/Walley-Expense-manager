import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:walley/utils/auth.dart';
import 'package:walley/utils/constants.dart';
import 'package:intl/intl.dart';

class Accounts extends StatefulWidget {
  const Accounts({Key? key}) : super(key: key);

  @override
  State<Accounts> createState() => _AccountsState();
}

class _AccountsState extends State<Accounts> {
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
                        .collection('accounts')
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
                                  leading: Text(
                                    documentSnapshot['icon'],
                                    style: TextStyle(fontSize: 22),
                                  ),
                                  title: Text(
                                    documentSnapshot['name'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: black,
                                    ),
                                  ),
                                  subtitle: Text(documentSnapshot['note'] == ''
                                      ? "Note"
                                      : documentSnapshot['note']),
                                  trailing: Text(
                                    "${formatCurrency.format(documentSnapshot['current'])}",
                                    style: TextStyle(
                                      color: darkGreen,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
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
