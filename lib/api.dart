import 'package:http/http.dart' as http;
import 'dart:convert';

class API {
  Future getAPIData(String url) async {
    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      String data = response.body;
      //print(json.decode(data));
      return json.decode(data);
    } else {
      print(response.statusCode);
    }
  }
}
