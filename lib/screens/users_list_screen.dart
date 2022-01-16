import 'package:flutter/material.dart';

class UsersListScreen extends StatefulWidget {
  UsersListScreen({Key? key}) : super(key: key);

  @override
  _UsersListScreenState createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  TextEditingController _searchTextController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Scaffold(
      appBar: AppBar(
        title: Text("Pharma Inc"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
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
                            hintText: 'Buscar',
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(width: 3, color: Colors.blue),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(width: 3, color: Colors.red),
                              borderRadius: BorderRadius.circular(15),
                            )),
                      ),
                    ),
                    SizedBox(width: 16),
                    InkWell(
                      child: Icon(Icons.filter_alt),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
