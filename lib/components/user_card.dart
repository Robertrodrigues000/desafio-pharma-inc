import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:pharmaapp/constants/colors.dart';
import 'package:pharmaapp/model/model.dart';

class UserCard extends StatefulWidget {
  final User? user;
  UserCard({Key? key, this.user}) : super(key: key);

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  double profileHeight = 144;
  double? top;
  String? thumbnail;
  String? name;
  String? lastName;
  String? middleName;
  String? gender;
  String? birth;
  String? email;
  String? phone;
  String? country;
  String? adress;
  String? id;

  @override
  Widget build(BuildContext context) {
    thumbnail = widget.user?.picture?.thumbnail ?? "";
    name = widget.user?.name?.first ?? "";
    lastName = widget.user?.name?.last ?? "";
    middleName = widget.user?.name?.title ?? "";
    gender = widget.user?.gender ?? "";
    email = widget.user?.email ?? "";
    birth = widget.user?.dob?.date ?? "";
    phone = widget.user?.phone ?? "";
    country = widget.user?.nat ?? "";
    adress =
        (widget.user?.location?.street?.name ?? "") + ", " + (widget.user?.location?.street?.number.toString() ?? "");
    id = widget.user?.id?.value ?? "";

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
              child: Center(child: CircleAvatar(radius: 30, backgroundImage: NetworkImage(thumbnail!))),
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
                            capitalize(gender!),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              letterSpacing: .3,
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            dateFormatDDMMYYYY(birth!) ?? "",
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
                  child: ListView(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    children: _alertDetailsViewContents(context, user),
                  ),
                ),
              ],
            ),
          );
        });
  }

  List<Widget> _alertDetailsViewContents(BuildContext context, user) {
    return <Widget>[
      _chartTitle(user),
      _chartSubTitle(user),
      customListTile(titleText: "Email: $email", leading: MaterialCommunityIcons.mail),
      customListTile(titleText: "Gênero: ${capitalize(gender!)}", leading: FontAwesome.transgender),
      customListTile(titleText: "Nascimento: ${dateFormatDDMMYYYY(birth!)}", leading: FontAwesome.birthday_cake),
      customListTile(titleText: "Telefone: $phone", leading: FontAwesome.phone),
      customListTile(titleText: "Nacionalidade: $country", leading: FontAwesome.globe),
      customListTile(titleText: "Endereço: $adress", leading: MaterialCommunityIcons.map_marker_radius_outline),
      customListTile(titleText: "Id: $id", leading: FontAwesome.id_card_o),
    ];
  }

  Widget customListTile({String? titleText, IconData? leading, TextAlign align = TextAlign.start}) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.only(left: 10),
          leading: Icon(
            leading,
            color: AppColors.orange,
          ),
          title: Text(titleText ?? "", style: TextStyle(color: Colors.black), textAlign: align),
        ),
        separator()
      ],
    );
  }

  Widget separator() {
    return Container(
      height: 1.0,
      width: double.infinity,
      color: Colors.black12,
    );
  }
//   Imagem
// Nome completo
// Email
// Gênero
// Data de nascimento
// Telefone
// Nacionalidade
// Endereço
// ID (Número de identificação)

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
