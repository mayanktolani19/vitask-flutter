import 'package:http/http.dart' as http;
import 'dart:convert';

class API {
  Future getAPIData(String url) async {
    http.Response response = await http.get(url);
    print(response.statusCode);
    if (response.statusCode == 200) {
      String data = response.body;
      return json.decode(data);
    }
  }
}
