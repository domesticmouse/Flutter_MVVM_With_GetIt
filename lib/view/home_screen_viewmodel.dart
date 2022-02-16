import 'package:flutter_mvvm_with_getit/provider/base_model.dart';

class HomeScreenViewModel extends BaseModel {
  int counter = 0;

  void incrementCounter() {
    counter++;
    notifyListeners();
  }
}
