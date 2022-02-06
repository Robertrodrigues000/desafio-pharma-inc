import 'package:flutter/material.dart';
import 'package:pharmaapp/components/country_filter.dart';
import 'package:pharmaapp/components/gender_filter.dart';
import 'package:pharmaapp/components/user_card.dart';
import 'package:pharmaapp/constants/colors.dart';
import 'package:pharmaapp/helpers/diacritics.dart';
import 'package:pharmaapp/model/model.dart';
import 'package:pharmaapp/screens/splash_screen.dart';
import 'package:pharmaapp/service/user_list_service.dart';

class UsersListScreen extends StatefulWidget {
  UsersListScreen({Key? key}) : super(key: key);

  @override
  UsersListScreenState createState() => UsersListScreenState();
}

class UsersListScreenState extends State<UsersListScreen> {
  TextEditingController _searchTextController = new TextEditingController();
  final ScrollController _scrollController = new ScrollController();
  final UserListService _userListService = new UserListService();
  List<dynamic> reFilteredList = [];
  String recordLastFilter = '';
  bool isFiltered = false;
  bool isGenderFilter = false;
  String wichGender = "";
  bool countryFilterHasFocus = false;

  double profileHeight = 144;
  double? top;
  late Model model;
  List<User>? userList;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      userList = await getDataFromService();
    });
    _scrollController.addListener(() async {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        userList = await getDataFromService();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<List<User>> getDataFromService() async {
    dynamic newList;
    try {
      model = await _userListService.getDataFormApi();
      setState(() {
        if (userList == null || userList!.isEmpty) {
          newList = model.results!;
        } else {
          newList = [...?userList, ...?model.results];
          if (mounted) setState(() {});
        }
      });
      return newList;
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    dynamic presentingList = [];
    if (_searchTextController.text.length < 1 && !isGenderFilter) {
      presentingList = userList;
      isFiltered = false;
    } else {
      presentingList = reFilteredList;
      isFiltered = true;
    }
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        countryFilterHasFocus = true;
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
          countryFilterHasFocus = false;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Pharma Inc"),
          backgroundColor: AppColors.lightBlue,
        ),
        bottomNavigationBar: InkWell(
          onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SplashScreen())),
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
        body: userList == null ? _renderNullList() : _renderListBody(presentingList),
      ),
    );
  }

  Stack _renderListBody(presentingList) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              AppColors.jadeGreen,
              Colors.white,
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20, right: 8, left: 8),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    CountryFilter(
                      function: (text) => searchFilteredResults(text),
                      searchTextController: _searchTextController,
                    ),
                    SizedBox(width: 20),
                    GenderFilter(
                      wichGender: wichGender,
                      filterGenderFunction: (text) => filterGenderFunction(text),
                    )
                  ],
                ),
              ),
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
    );
  }

  Stack _renderNullList() {
    return Stack(fit: StackFit.expand, children: [
      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            AppColors.jadeGreen,
            Colors.white,
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
      ),
      Center(
        child: CircularProgressIndicator(),
      )
    ]);
  }

  Widget _renderProgressIndicator() {
    return Container(
      padding: EdgeInsets.only(
        bottom: 80,
        top: 40,
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

  void searchFilteredResults(String text) {
    recordLastFilter = text;
    dynamic result = _countryFilter(text);
    reFilteredList = result;
    setState(() {});
  }

  List<User> _countryFilter(String searchText) {
    List<User> newUserList = [];
    newUserList = userList!
        .where((element) => Diacritics.remove(element.nat!.toLowerCase()).contains(searchText.toLowerCase()))
        .toList();
    return newUserList;
  }

  void filterGenderFunction(text) {
    _scrollController.animateTo(0, duration: Duration(milliseconds: 500), curve: Curves.linear);
    wichGender = text;
    if (text == "") {
      isGenderFilter = false;
      reFilteredList = userList!;
      setState(() {});
    } else {
      isGenderFilter = true;
      List<User> newUserList = [];
      newUserList = userList!.where((element) => element.gender == text).toList();
      reFilteredList = newUserList;
      setState(() {});
    }
  }
}
