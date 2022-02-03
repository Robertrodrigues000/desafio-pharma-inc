import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pharmaapp/model/model.dart';
import 'package:pharmaapp/service/user_list_service.dart';

import 'fetch_mock.dart';

// Generate a MockClient using the Mockito package.
// Create new instances of this class in each test.
@GenerateMocks([http.Client])
void main() {
  group('test api', () {
    test("get data sucessfull", () async {
      UserListMock userlistmock = UserListMock();
      UserListService _userListService = UserListService();
      Model model = Model(
        results: [User(name: Name(title: "Mrs", first: "Alea", last: "Christoffersen"), gender: "female")],
        info: Info(seed: "2f10116f1799d353", results: 1, page: 1, version: "1.3"),
      );
      dynamic result;

      when(userlistmock.getDataFormApi()).thenAnswer((any) async => model);

      result = await _userListService.getDataFormApi();

      verify(userlistmock.getDataFormApi()).called(1);
      expect(result is List<User>, true);
      // expect(result[0], 200);
      // expect(resultList[0].hasMore, true);
      // expect(resultList[0].cursor, 'ABC');
      // expect(resultList[1] is List<Alert>, true);
      // expect(resultList[1].length, 1);
      // expect(resultList[1][0].description, 'Alert Zero');
    });
    test('throws an exception if the http call completes with an error', () async {
      UserListMock Mokeduserlist = UserListMock();
      UserListService _userListService = UserListService();
      Model model = Model(
        results: [User(name: Name(title: "Mrs", first: "Alea", last: "Christoffersen"), gender: "female")],
        info: Info(seed: "2f10116f1799d353", results: 1, page: 1, version: "1.3"),
      );
      dynamic result;
      Response searchResponse = Response(
        'TESTE',
        404,
        headers: {'pagination-has-more': 'false', 'pagination-total-items': '0', 'pagination-cursor': 'ABC'},
      );

      when(Mokeduserlist.getDataFormApi()).thenAnswer((any) async => null);

      result = await _userListService.getDataFormApi();

      verify(Mokeduserlist.getDataFormApi()).called(1);
      expect(result is List<User>, true);
    });
  });
}
