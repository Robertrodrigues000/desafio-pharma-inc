import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pharmaapp/model/model.dart';


class UserListService {
  Future<dynamic> getDataFormApi() async {
          final url = await http.get(Uri.parse("https://randomuser.me/api/?results=50"));
      return Model.fromJson(jsonDecode(url.body));

  }
}