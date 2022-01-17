import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pharmaapp/constants/colors.dart';
import 'package:http/http.dart' as http;
import 'package:pharmaapp/model/model.dart';

class UsersListScreen extends StatefulWidget {
  UsersListScreen({Key? key}) : super(key: key);

  @override
  _UsersListScreenState createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  TextEditingController _searchTextController = new TextEditingController();

  Model? model;
  List<Results>? list;

  @override
  void initState() {
    super.initState();
    getDataFromApi();
  }

  Future getDataFromApi() async {
    final url = await http.get(Uri.parse("https://randomuser.me/api"));
    model = Model.fromJson(jsonDecode(url.body));
    setState(() {
      list = model?.results!;
    });
    print(list?[0].name?.first);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Scaffold(
      appBar: AppBar(
        title: Text("Pharma Inc"),
      ),
      body: list == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.only(top: 40, right: 8, bottom: 8, left: 8),
              child: Column(
                children: [
                  Center(
                    child: Text(
                      "Lista de Usuários",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40, right: 8, bottom: 8, left: 8),
                    child: Container(
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _searchTextController,
                              decoration: InputDecoration(
                                  suffixIcon: Icon(
                                    Icons.search,
                                    color: Colors.black,
                                    size: 20.0,
                                  ),
                                  hintText: 'Buscar usuário',
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(width: 3, color: AppColors.lightBlue),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(width: 3, color: AppColors.orange),
                                  )),
                            ),
                          ),
                          SizedBox(width: 30),
                          InkWell(
                            child: Icon(Icons.filter_alt, size: 30),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Center(child: Text(list?[0].name?.first ?? ""))
                ],
              ),
            ),
    ));
  }

  String myMethod(String? myString) {
    if (myString == null) {
      return '';
    }

    return myString;
  }
}
