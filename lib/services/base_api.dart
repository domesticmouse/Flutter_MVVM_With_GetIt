/*-----------File to manage all kinds of http requests---------------*/

import 'dart:io';
import 'package:flutter_mvvm_with_getit/services/prefs_services.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';

import 'package:flutter/foundation.dart';
import 'api_response.dart';
import 'http_exception.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class BaseApi {
  final String _baseUrl = '<Your Server URL here>';
  // final String _baseUrl = '192.168.1.12:3000';
  final String _authToken = Prefs().getToken();

//TODO: need of api for google login
  Future<void> googleLogIn(Map data, String endpoint) async {

    try {
      final uri = Uri.https(_baseUrl, endpoint);
      if (kDebugMode) {
        print(uri);
      }
      final response = await http.post(uri, body: data);
      if (kDebugMode) {
        print(response.statusCode);
      }
      if (response.statusCode == 200) {
      } else {
        Map<String, dynamic> data = jsonDecode(response.body);

        String error = 'Error occurred';
        for (var key in data.keys) {
          if (key.contains('error')) {
            error = data[key][0];
            if (kDebugMode) {
              print(error);
            }
          }
        }
        throw HttpException(message: error);
      }
    } on SocketException {
      throw HttpException(message: 'No Internet Connection');
    } catch (e) {
      rethrow;
    }
  }

//TODO: need of diff get req with & w/o auth
  //GET
  Future<ApiResponse> getRequest(
      {required String endpoint, Map<String, Object>? query}) async {
    final uri = Uri.https(_baseUrl, endpoint, query);
    if (kDebugMode) {
      print(uri);
    }
    return processResponse(await http.get(uri));
  }

  //GET Without Auth
  Future<ApiResponse> getWithoutAuthRequest(
      {required String endpoint, Map<String, String>? query}) async {
    final uri = Uri.http(_baseUrl, endpoint, query);
    if (kDebugMode) {
      print(uri);
    }
    return processResponse(await http.get(
      uri,
    ));
  }

  //POST
  Future<ApiResponse> postRequest(
      String endpoint, Map<String, dynamic> data) async {
    if (kDebugMode) {
      print("posttttttttttttttttttt");
    }
    final uri = Uri.http(_baseUrl, endpoint);
    if (kDebugMode) {
      print(uri);
    }
    return processResponse(
      await http.post(uri, body: data),
    );
  }

  // PUT
  Future<ApiResponse> patchRequest(
      String endpoint, Map<String, dynamic> data) async {
    final uri = Uri.https(_baseUrl, endpoint);
    if (kDebugMode) {
      print(uri);
    }
    return processResponse(await http.patch(uri,
        headers: {
          HttpHeaders.authorizationHeader: 'Token $_authToken',
        },
        body: data));
  }

  // DELETE
  Future<ApiResponse> deleteRequest(
      {required String endpoint, required String id}) async {
    final String endPointUrl = id.isEmpty ? endpoint : '$endpoint/' '$id/';
    if (kDebugMode) {
      print(endPointUrl);
    }
    final uri = Uri.https(_baseUrl, endPointUrl);
    if (kDebugMode) {
      print(uri);
    }
    return processResponse(await http.delete(
      uri,
      headers: {
        HttpHeaders.authorizationHeader: 'Token $_authToken',
      },
    ));
  }

  //function to process responses for all kind of requests - POST,PUT,DELETE,GET
  Future<ApiResponse> processResponse(Response response) async {
    // if (_authToken.isEmpty || _authToken == null) {
    //   print('not logged in');
    //   return ApiResponse(error: true, errorMessage: 'User not logged in');
    // }
    try {
      if (response.statusCode >= 200 && response.statusCode <= 207) {
        if (kDebugMode) {
          print('==');
        }
        return ApiResponse(data: jsonDecode(response.body));
      } else {
        Map<String, dynamic> data = jsonDecode(response.body);
        String error = 'Error occurred';
        for (var key in data.keys) {
          if (key.contains('error')) {
            error = data[key][0];
            if (kDebugMode) {
              print(error);
            }
          }
        }
        return ApiResponse(error: true, errorMessage: error);
      }
    } on SocketException {
      if (kDebugMode) {
        print('socket');
      }
      throw HttpException(message: 'No Internet Connection');
    } on PlatformException catch (error) {
      if (kDebugMode) {
        print('plt');
      }
      throw HttpException(message: error.toString());
    } catch (e) {
      rethrow;
    }
  }
}
