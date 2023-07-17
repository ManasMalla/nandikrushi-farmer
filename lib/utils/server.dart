import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart';
import 'package:nandikrushi_farmer/utils/api_exceptions.dart';

class Server {
  Future<dynamic> getMethodParams(String api) async {
    var uri = Uri.parse(api);

    try {
      return get(uri).timeout(const Duration(seconds: 30));
    } on SocketException {
      throw FetchDataException('No Internet Connection', uri.toString());
    } on TimeoutException {
      throw APINotRespondingException(
          'API Not Responding in Time', uri.toString());
    }
  }

  Future<Response?> postFormData(
      {Map<String, String> body = const {}, String url = ""}) async {
    var uri = Uri.tryParse(url);

    if (uri != null) {
      log(body.toString());
      var request = MultipartRequest("POST", uri);
      request.fields.addAll(body);
      var sendRequest = await request.send();
      var response = await Response.fromStream(sendRequest);
      return response;
    } else {
      return null;
    }
  }
}
