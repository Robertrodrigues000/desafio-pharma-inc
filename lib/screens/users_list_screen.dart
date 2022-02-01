import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pharmaapp/components/filter.dart';
import 'package:pharmaapp/components/user_card.dart';
import 'package:pharmaapp/constants/colors.dart';
import 'package:http/http.dart' as http;
import 'package:pharmaapp/helpers/diacritics.dart';
import 'package:pharmaapp/model/model.dart';

class UsersListScreen extends StatefulWidget {
  UsersListScreen({Key? key}) : super(key: key);

  @override
  _UsersListScreenState createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  TextEditingController _searchTextController = new TextEditingController();
  final ScrollController _scrollController = new ScrollController();
  List<dynamic> firstFilteredList = [];
  List<dynamic> reFilteredList = [];
  String recordLastFilter = '';
  bool isFiltered = false;

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
    final url = await http.get(Uri.parse("https://randomuser.me/api/?results=10"));
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
    dynamic presentingList = [];
    if (_searchTextController.text.length < 1) {
      presentingList = userList;
      isFiltered = false;
    } else {
      presentingList = reFilteredList;
      isFiltered = true;
    }
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Pharma Inc"),
          backgroundColor: AppColors.lightBlue,
        ),
        bottomNavigationBar: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            height: 50,
            color: AppColors.lightBlue,
            child: Center(
                child: Icon(
              Icons.house,
              size: 40,
              color: Colors.white,
            )),
          ),
        ),
        body: userList == null
            ? Stack(fit: StackFit.expand, children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      AppColors.lightBlue,
                      Colors.white,
                    ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                  ),
                ),
                Center(
                  child: CircularProgressIndicator(),
                )
              ])
            : Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        AppColors.lightBlue,
                        Colors.white,
                      ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0, right: 8, left: 8),
                    child: Column(
                      children: [
                        Filter(
                          searchTextController: _searchTextController,
                          userList: userList,
                          function: filterFunction(),
                        ),
                        SizedBox(height: 20),
                        Expanded(
                          child: ListView.builder(
                            controller: _scrollController,
                            itemCount: (presentingList?.length ?? 0) + 1,
                            itemBuilder: (context, index) {
                              dynamic user;
                              if (index < (presentingList?.length ?? 0)) {
                                user = presentingList?[index];
                                user = UserCard(user: user);
                              } else {
                                user = isFiltered ? Container() : _renderProgressIndicator();
                              }
                              return user;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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
      child: Center(
        child: Container(
          width: 200,
          child: Row(
            children: [
              Container(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.orange,
                    ),
                    backgroundColor: Colors.transparent,
                  )),
              SizedBox(width: 20),
              Text(
                "Buscando mais...",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.orange),
              )
            ],
          ),
        ),
      ),
    );
  }

  Function filterFunction() {
    return (text) async => await _searchForMatchingResults(text);
  }

  Future _searchForMatchingResults(String text) async {
    await searchFilteredResults(text);
    setState(() {});
  }

  Future<void> searchFilteredResults(String text) async {
    recordLastFilter = text;
    var result = _filterOperators(text);
    if (result is List) {
      firstFilteredList = result;
      reFilteredList = firstFilteredList;
    }
  }

  List<User> _filterOperators(String searchText) {
    List<User> newUserList = [];
    newUserList = userList!
        .where((element) => Diacritics.remove(element.nat!.toLowerCase()).contains(searchText.toLowerCase()))
        .toList();
    return newUserList;
  }
}
