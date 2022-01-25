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
    final url = await http.get(Uri.parse("https://randomuser.me/api/?results=50"));
    model = Model.fromJson(jsonDecode(url.body));
    setState(() {
      list = model?.results!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Pharma Inc"),
        ),
        bottomNavigationBar: Stack(
          children: [
            Container(
              height: 70,
              color: AppColors.jadeGreen,
              child: Center(
                  child: Icon(
                Icons.house,
                size: 40,
                color: Colors.white,
              )),
            ),
          ],
        ),
        body: list == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.only(top: 40, right: 8, left: 8),
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        "Lista de Usuários",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    _renderFilter(),
                    SizedBox(height: 30),
                    Expanded(
                      child: ListView.builder(
                        itemCount: list?.length,
                        itemBuilder: (context, index) {
                          final user = list?[index];
                          return _renderUserCard(context, user);
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _renderUserCard(BuildContext context, Results? user) {
    String thumbnail = user?.picture?.thumbnail ?? "";
    String name = user?.name?.first ?? "";
    String lastName = user?.name?.last ?? "";
    String middleName = user?.name?.title ?? "";
    String gender = user?.gender?.toUpperCase() ?? "";
    String city = user?.location?.city ?? "";
    String birth = user?.dob?.date ?? "";
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: AppColors.deepBlue,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      width: double.maxFinite,
      height: 110,
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: CircleAvatar(radius: 20, backgroundImage: NetworkImage(thumbnail))),
          ),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "$middleName $name $lastName",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                          color: Colors.blue,
                          child: Text(gender, style: TextStyle(color: Colors.white, fontSize: 13, letterSpacing: .3))),
                      Container(
                        child: Text(dateFormatDDMMYYYY(birth) ?? "",
                            style: TextStyle(color: Colors.white, fontSize: 13, letterSpacing: .3)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Padding _renderFilter() {
    return Padding(
      padding: const EdgeInsets.only(top: 40, right: 8, bottom: 8, left: 8),
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
                    borderSide: const BorderSide(width: 5, color: AppColors.jadeGreen),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 5, color: AppColors.orange),
                  )),
            ),
          ),
          SizedBox(width: 30),
          InkWell(child: Icon(Icons.filter_alt, size: 30))
        ],
      ),
    );
  }

  String? dateFormatDDMMYYYY(String day) {
    if (day.contains("T")) {
      String date = day.split("T")[0];
      date = date.split("-")[2] + "/" + date.split("-")[1] + "/" + date.split("-")[0];
      return date;
    }
  }
}
