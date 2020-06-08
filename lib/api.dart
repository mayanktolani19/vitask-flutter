import 'package:http/http.dart' as http;
import 'dart:convert';

class API {
  Future getAPIData(String url, Map<String, String> body) async {
    String msg = jsonEncode(body);
    http.Response response;
    try {
      response = await http.post(
        url,
        body: msg,
        headers: {
          'Content-Type': 'application/json',
          'X-VITASK-API':
              'ed83118d24cb1bd4458ab10ed1db49bf9416597a86914cb6fd7e25318bf344a5c335583e7eb1a37982c0d446015c6ff2de76e161b77db9b4a01d26d71d507d14'
        },
      );
      print(response.statusCode);
    } catch (e) {
      print(e);
    }
    if (response.statusCode == 200 || response.statusCode == 201) {
      String data = response.body;
      return json.decode(data);
    }
  }
}
