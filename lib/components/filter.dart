import 'package:flutter/material.dart';
import 'package:pharmaapp/constants/colors.dart';
import 'package:pharmaapp/helpers/diacritics.dart';
import 'package:pharmaapp/model/model.dart';
import 'package:pharmaapp/screens/users_list_screen.dart';

class Filter extends StatefulWidget {
  final dynamic searchTextController;
  final dynamic userList;
  final dynamic function;
  const Filter({Key? key, this.searchTextController, this.userList, this.function}) : super(key: key);

  @override
  _FilterState createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40, right: 8, bottom: 8, left: 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: widget.searchTextController,
              decoration: InputDecoration(
                  suffixIcon: Icon(
                    Icons.search,
                    color: Colors.black,
                    size: 20.0,
                  ),
                  hintText: 'Buscar nacionalidade',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 3, color: AppColors.deepBlue),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 3, color: AppColors.jadeGreen),
                    borderRadius: BorderRadius.circular(15),
                  )),
              onChanged: widget.function,
            ),
          ),
          SizedBox(width: 30),
          InkWell(child: Icon(Icons.filter_alt, size: 30))
        ],
      ),
    );
  }
}
