import 'dart:convert';
import 'package:http/http.dart';
import 'package:pharmaapp/model/model.dart';


class UserListService {
  final url ="https://randomuser.me/api/?results=50";
  Client client = Client();

  Future<dynamic> getDataFormApi() async {
    try {
      final response = await client.get(Uri.parse(url));
      return Model.fromJson(jsonDecode(response.body));
    } catch (e) {
      throw e;
    }
          

  }
}