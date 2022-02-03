import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mockito/mockito.dart';
import 'package:pharmaapp/screens/users_list_screen.dart';
import 'package:pharmaapp/service/user_list_service.dart';

class UserListMock extends Mock implements UserListService {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.debug}) {
    return super.toString();
  }
}