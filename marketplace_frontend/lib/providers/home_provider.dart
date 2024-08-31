import 'package:marketplace/providers/base_provider.dart';

class HomeProvider extends DisposableProvider {
  // get from backend
  List<String> storeCategories = [
    'All',
    'Electronics',
    'Fashion',
    'Home',
    'Beauty',
    'Toys',
    'Grocery',
    'Sports',
    'Books',
    'Furniture',
    'Automotive',
    'Others',
  ];

  String selectedCategory = "All";

  void updateSelectedCategory(String text) {
    selectedCategory = text;
    notifyListeners();
  }

  @override
  void disposeValues() {
    selectedCategory = "All";
  }
}
