class Record {
  String type = 'Expense';
  String account = '';
  String location = '';
  String category = 'Food';
  String note = '';
  String date = '';
  String time = '';
  DateTime timestamp = DateTime.now().toUtc();
  double amount = 0;
}

class Budget {
  String account = '';
  List<Map<String, String>> categories = [];
  String name = 'New Budget';
  String period = 'Monthly';
  double amount = 0.0;
  DateTime timestamp = DateTime.now().toUtc();
  int remDays = 0;
  int totalDays = 0;
  double spent = 0;
}

class Goal {
  String name = 'New Goal';
  DateTime date = DateTime.now().add(Duration(days: 30));
  DateTime timestamp = DateTime.now();
  String note = '';
  double initial = 0;
  double target = 0;
}

class Account {
  String name = 'New Account';
  double inital = 0;
  double current = 0;
  String note = '';
  bool excludeFromStats = false;
  double expense = 0;
  double income = 0;
  String icon = '🏦';
  DateTime timestamp = DateTime.now();
}
