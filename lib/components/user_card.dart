import 'package:flutter/material.dart';
import 'package:pharmaapp/constants/colors.dart';
import 'package:pharmaapp/model/model.dart';

class UserCard extends StatefulWidget {
  final dynamic user;
  UserCard({Key? key, this.user}) : super(key: key);

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
    double profileHeight = 144;
  double? top;

  @override
  Widget build(BuildContext context) {
    String thumbnail = widget.user?.picture?.thumbnail ?? "";
    String name = widget.user?.name?.first ?? "";
    String lastName = widget.user?.name?.last ?? "";
    String middleName = widget.user?.name?.title ?? "";
    String gender = widget.user?.gender ?? "";
    String birth = widget.user?.dob?.date ?? "";

    return InkWell(
      onTap: () => _configurandoModalBottomSheet(context, widget.user),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: AppColors.deepBlue,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
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
              child: Center(child: CircleAvatar(radius: 30, backgroundImage: NetworkImage(thumbnail))),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 200,
                    child: Text(
                      "$middleName $name $lastName",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  Container(
                    width: 220,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: Text(
                            capitalize(gender),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              letterSpacing: .3,
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            dateFormatDDMMYYYY(birth) ?? "",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              letterSpacing: .3,
                            ),
                          ),
                        ),
                      ],
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

  void _configurandoModalBottomSheet(context, user) {
    top = MediaQuery.of(context).size.height * 0.7 - profileHeight / 2;
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
        ),
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Positioned(
                  bottom: top,
                  child: CircleAvatar(
                      radius: profileHeight / 2,
                      backgroundColor: Colors.grey.shade800,
                      backgroundImage: NetworkImage(user?.picture?.large ?? "")),
                ),
                Container(
                  margin: EdgeInsets.only(top: profileHeight / 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Wrap(
                        children: [
                          _chartTitle(user),
                          _chartSubTitle(user),
                        ],
                      ),
                      ListTile(
                        leading: Icon(Icons.phone),
                        title: Text('Call phone'),
                        onTap: () {
                          print('Call phone');
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }


  
  Center _chartTitle(User user) {
    return Center(
      child: Text(
        (user.name?.title ?? "") + " " + (user.name?.first ?? ""),
        style: TextStyle(color: Colors.black, fontSize: 32),
      ),
    );
  }

  Center _chartSubTitle(user) {
    return Center(
      child: Text(
        user.name?.last ?? "",
        overflow: TextOverflow.clip,
        style: TextStyle(color: Colors.black.withOpacity(.7), fontSize: 20),
      ),
    );
  }


  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  String? dateFormatDDMMYYYY(String day) {
    if (day.contains("T")) {
      String date = day.split("T")[0];
      date = date.split("-")[2] + "/" + date.split("-")[1] + "/" + date.split("-")[0];
      return date;
    }
  }
}
