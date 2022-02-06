import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mockito/mockito.dart';
import 'package:pharmaapp/service/user_list_service.dart';

class UserListServiceMock extends Mock implements UserListService {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.debug}) {
    return super.toString();
  }
}