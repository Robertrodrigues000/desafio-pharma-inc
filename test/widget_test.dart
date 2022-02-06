import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:pharmaapp/model/model.dart';
import 'package:pharmaapp/service/user_list_service.dart';
import 'dart:convert';


// Generate a MockClient using the Mockito package.
// Create new instances of this class in each test.
void main() {
  final service = UserListService();
  group('test api', () {
    test("get data sucessfull", () async {
      service.client = MockClient((request) async {
        final mapJson = {
          "results": [
            {
              "gender": "female",
              "name": {"title": "Ms", "first": "Alea", "last": "Christoffersen"}
            }
          ],
          "info": {"seed": "2f10116f1799d353", "results": 1, "page": 1, "version": "1.3"}
        };
        return Response(json.encode(mapJson), 200);
      });

      Model result = await service.getDataFormApi();

      expect(result.results is List<User>, true);
      expect(result.results?[0].gender, "female");
      expect(result.results?[0].name?.first, "Alea");
      expect(result.results?[0].name?.last, "Christoffersen");
    });
    test('throws an exception if the http call completes with an error', () async {
      service.client = MockClient((request) async {   
        return Response('Not Found', 404);
      });

      expect(service.getDataFormApi(), throwsException);
    });
  
  });
}
