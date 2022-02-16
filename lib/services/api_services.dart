/*-----------------file containing methods for calling http requests */

import 'package:flutter_mvvm_with_getit/services/api_response.dart';
import 'package:flutter_mvvm_with_getit/services/api_urls.dart';
import 'package:flutter_mvvm_with_getit/services/base_api.dart';

class ApiService extends BaseApi {
  // Login ViewModel

  Future<ApiResponse> getArticlesMethod({required String endpoint}) async {
    ApiResponse response;
    try {
      response = await getRequest(endpoint: endpoint);
      print('no error');
    } catch (e) {
      response = ApiResponse(error: true, errorMessage: e.toString());
    }
    return response;
  }
}
