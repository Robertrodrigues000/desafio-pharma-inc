import 'package:flutter/material.dart';
import 'package:pharmaapp/constants/colors.dart';

class CountryFilter extends StatefulWidget {
  final dynamic searchTextController;
  final dynamic function;
  const CountryFilter({Key? key, this.searchTextController, this.function}) : super(key: key);

  @override
  _CountryFilterState createState() => _CountryFilterState();
}

class _CountryFilterState extends State<CountryFilter> {
  FocusNode focusNode = FocusNode();
  String hintText = "Buscar nacionalidade";
  String? popUpValue;

  void initState() {
    super.initState();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        hintText = '';
      } else {
        hintText = "Buscar nacionalidade";
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextField(
        controller: widget.searchTextController,
        focusNode: focusNode,
        showCursor: true,
        cursorColor: Colors.white,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
            suffixIcon: Icon(
              Icons.search,
              color: Colors.black,
              size: 20.0,
            ),
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.white),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 3, color: AppColors.deepBlue),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 3, color: AppColors.lightBlue),
              borderRadius: BorderRadius.circular(15),
            )),
        onChanged: widget.function,
      ),
    );
  }
}
