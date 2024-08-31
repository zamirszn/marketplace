import 'package:marketplace/providers/base_provider.dart';

class BottomNavProvider extends DisposableProvider {
  int currentIndex = 0;

  void setCurrentIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }

  @override
  void disposeValues() {
    currentIndex = 0;
  }
}
