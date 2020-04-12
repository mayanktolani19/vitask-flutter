import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileAPI {
  ProfileAPI(this.url);
  String url;
  Future getProfileData() async {
    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      String data = response.body;
      print(json.decode(data));
      return json.decode(data);
    } else {
      print(response.statusCode);
    }
  }
}
