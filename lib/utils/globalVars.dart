import 'package:get/get.dart';
import 'package:walley/utils/models.dart';

class GlobalVars extends GetxController {
  List<Account> accounts = [];
  List<Map<String, String>> expenseCategories = [
    {"icon": "🍜", "title": "Food"},
    {"icon": "🍺", "title": "Drinks"},
    {"icon": "🍕", "title": "Restraunt"},
    {"icon": "🛍️", "title": "Shopping"},
    {"icon": "👕", "title": "Cloths"},
    {"icon": "👟", "title": "Shoes"},
    {"icon": "💊", "title": "Medication"},
    {"icon": "🏠", "title": "Housing"},
    {"icon": "🪙", "title": "Tax"},
    {"icon": "🎧", "title": "Electronics"},
    {"icon": "🎁", "title": "Gifts"},
    {"icon": "💄", "title": "Beauty"},
    {"icon": "🧼", "title": "Personal Hygiene"},
    {"icon": "🚌", "title": "Public Transport/Taxi"},
    {"icon": "🚗", "title": "Personal Transport"},
    {"icon": "💎", "title": "Jewels/Accessories"},
    {"icon": "🍼", "title": "Kids"},
    {"icon": "🐕", "title": "Pets"},
    {"icon": "✂️", "title": "Stationary/Tools"},
    {"icon": "✈️", "title": "Air travel"},
    {"icon": "🏸", "title": "Sports"},
    {"icon": "📕", "title": "Books"},
    {"icon": "💳", "title": "Subscriptions"},
    {"icon": "🎓", "title": "Education"},
    {"icon": "🌴", "title": "Vacation/Trips"},
    {"icon": "📺", "title": "TV"},
    {"icon": "📶", "title": "Internet"},
    {"icon": "💻", "title": "Softwares/Applications"},
    {"icon": "💶", "title": "Loans/Fees"},
    {"icon": "🏦", "title": "Investments"},
  ];
  List<Map<String, String>> incomeCategories = [
    {"icon": "💵", "title": "Income"},
    {"icon": "✅", "title": "Dues"},
    {"icon": "🤑", "title": "Bonus"},
    {"icon": "🧧", "title": "Gift"},
    {"icon": "🏡", "title": "Rental Income"},
  ];

  setAccount(Account account) {
    accounts.add(account);
    update();
  }

  removeAllAccounts() {
    accounts = [];
    update();
  }
}
