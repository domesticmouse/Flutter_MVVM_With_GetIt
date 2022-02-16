import 'package:flutter_mvvm_with_getit/services/api_services.dart';
import 'package:flutter_mvvm_with_getit/services/navigation_service.dart';
import 'package:flutter_mvvm_with_getit/view/home_screen_viewmodel.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;
void setupLocator() {
  getIt.registerLazySingleton(() => NavigationService());
  getIt.registerFactory(() => ApiService());
  getIt.registerFactory(() => HomeScreenViewModel());
}
