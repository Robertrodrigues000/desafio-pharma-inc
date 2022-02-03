import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:pharmaapp/constants/colors.dart';

class GenderFilter extends StatefulWidget {
    final dynamic filterGenderFunction;
  final String wichGender;

  const GenderFilter({ Key? key, this.filterGenderFunction, required this.wichGender }) : super(key: key);

  @override
  _GenderFilterState createState() => _GenderFilterState();
}

class _GenderFilterState extends State<GenderFilter> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
            color: AppColors.deepBlue,
            elevation: 20,
            shape: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey, width: 2)),
            onSelected: widget.filterGenderFunction,
            child: Icon(
              getGenderIcon(),
              size: 30,
              color: AppColors.deepBlue,
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text(
                  "Todos",
                  style: TextStyle(color: Colors.white),
                ),
                value: "",
              ),
              PopupMenuItem(
                child: Text(
                  "Mulheres",
                  style: TextStyle(color: Colors.white),
                ),
                value: "female",
              ),
              PopupMenuItem(
                child: Text(
                  "Homens",
                  style: TextStyle(color: Colors.white),
                ),
                value: "male",
              )
            ],
          );
  }


  dynamic getGenderIcon() {
    if (widget.wichGender == "") return MaterialCommunityIcons.filter_variant;
    if (widget.wichGender == "male") return Ionicons.md_male_sharp;
    if (widget.wichGender == "female") return Ionicons.md_female_sharp;
  }
}