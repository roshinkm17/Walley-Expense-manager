import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:walley/utils/models.dart';

addRecordStatsOnAccount(String email, Record record) async {
  CollectionReference reference = FirebaseFirestore.instance
      .collection('users')
      .doc(email)
      .collection('accounts');
  var res =
      await reference.where('name', isEqualTo: record.account).limit(1).get();
  print("adding stats on account" + record.account);
  var doc = res.docs[0];
  if (record.type == 'Expense') {
    return await reference.doc(doc.id).update({
      'expense': doc['expense'] + record.amount,
      'current': doc['current'] - record.amount,
    });
  } else if (record.type == 'Income') {
    return await reference.doc(doc.id).update({
      'income': doc['income'] + record.amount,
      'current': doc['current'] + record.amount,
    });
  }
}

addRecordStatsOnBudgets(String email, Record record) async {
  print("adding to budgets");
  CollectionReference reference = FirebaseFirestore.instance
      .collection('users')
      .doc(email)
      .collection('budgets');
  try {
    var res = await reference.get();
    var docs = res.docs;
    docs.forEach((doc) {
      var data = doc.data() as dynamic;
      List<dynamic> category = data['category'];
      category.forEach((obj) {
        if (obj['title'] == record.category) {
          update() async {
            await reference.doc(doc.id).update({
              'spent': data['spent'] + record.amount,
            });
            return;
          }

          update();
        }
      });
    });
  } catch (e) {
    print(e);
  }
}

addRecordToFirebase(String email, Record record) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference reference =
      firestore.collection('users').doc(email).collection('records');
  try {
    await addRecordStatsOnAccount(email, record);
    await addRecordStatsOnBudgets(email, record);
    return await reference.add({
      'type': record.type,
      'account': record.account,
      'location': record.location,
      'category': record.category,
      'note': record.note,
      'date': record.date,
      'time': record.time,
      "amount": record.amount,
      "timestamp": record.timestamp,
    });
  } catch (error) {
    print(error);
    return error;
  }
}

addBudgetToFirebase(String email, Budget budget) async {
  try {
    CollectionReference reference = FirebaseFirestore.instance
        .collection('users')
        .doc(email)
        .collection('budgets');
    return await reference.add({
      'account': budget.account,
      'category': budget.categories,
      'name': budget.name,
      'amount': budget.amount,
      'period': budget.period,
      'remDays': budget.remDays,
      'totalDays': budget.totalDays,
      'timestamp': budget.timestamp,
      'spent': budget.spent,
    });
  } catch (e) {
    print(e);
    return e;
  }
}

addGoalToFirebase(String email, Goal goal) async {
  try {
    CollectionReference reference = FirebaseFirestore.instance
        .collection('users')
        .doc(email)
        .collection('goals');
    return await reference.add({
      'name': goal.name,
      'note': goal.note,
      'date': goal.date,
      'initial': goal.initial,
      'target': goal.target,
      'timestamp': goal.timestamp
    });
  } catch (e) {
    print(e);
    return e;
  }
}

addAccountToFirebase(String email, Account account) async {
  try {
    CollectionReference reference = FirebaseFirestore.instance
        .collection('users')
        .doc(email)
        .collection('accounts');
    return await reference.add({
      'name': account.name,
      'note': account.note,
      'current': account.inital,
      'expense': account.expense,
      'income': account.income,
      'initial': account.inital,
      'icon': account.icon,
      'excludeFromStats': account.excludeFromStats,
      'timestamp': account.timestamp
    });
  } catch (e) {
    print(e);
    return e;
  }
}

getAccountsFromFirebase(String email) async {
  try {
    CollectionReference reference = FirebaseFirestore.instance
        .collection('users')
        .doc(email)
        .collection('accounts');
    return await reference.get();
  } catch (e) {
    print(e);
    return e;
  }
}
