import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pharmaapp/components/user_card.dart';
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
  final ScrollController _scrollController = new ScrollController();
  double profileHeight = 144;
  double? top;
  late Model model;
  List<User>? userList;

  @override
  void initState() {
    super.initState();
    getDataFromApi();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        getDataFromApi();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future getDataFromApi() async {
    final url = await http.get(Uri.parse("https://randomuser.me/api/?results=50"));
    model = Model.fromJson(jsonDecode(url.body));
    setState(() {
      if (userList == null || userList!.isEmpty) {
        userList = model.results!;
      } else {
        userList = [...?userList, ...?model.results];
        if (mounted) setState(() {});
      }
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
              height: 50,
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
        body: userList == null
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
                        controller: _scrollController,
                        itemCount: (userList?.length ?? 0) + 1,
                        itemBuilder: (context, index) {
                          dynamic user;
                          if (index < (userList?.length ?? 0)) {
                            user = userList?[index];
                            user = UserCard(user: user);
                          } else {
                            user = _renderProgressIndicator();
                          }
                          return user;
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _renderProgressIndicator() {
    return Container(
      padding: EdgeInsets.only(
        bottom: 120,
        top: 10,
      ),
      child: Column(
        children: [
          Center(
            child: Container(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.jadeGreen,
                  ),
                  backgroundColor: Colors.transparent,
                )),
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
                    borderRadius: BorderRadius.circular(15),
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

  Wrap listTiles() {
    return Wrap(
      children: <Widget>[
        ListTile(leading: new Icon(Icons.music_note), title: new Text('Músicas'), onTap: () => {}),
        ListTile(
          leading: new Icon(Icons.videocam),
          title: new Text('Videos'),
          onTap: () => {},
        ),
        ListTile(
          leading: new Icon(Icons.satellite),
          title: new Text('Tempo'),
          onTap: () => {},
        ),
      ],
    );
  }
}
