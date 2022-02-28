import 'package:flutter_mvvm_with_getit/enum/view_state.dart';
import 'package:flutter_mvvm_with_getit/provider/getit.dart';
import 'package:flutter_mvvm_with_getit/services/navigation_service.dart';
import 'package:flutter/material.dart';

class BaseModel extends ChangeNotifier {
  final navigationService = getIt<NavigationService>();
  ViewState _state = ViewState.idle;

  ViewState get state => _state;
  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }
}
