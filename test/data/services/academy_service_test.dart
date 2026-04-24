import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sibaha_app/core/exceptions/app_exceptions.dart';
import 'package:sibaha_app/data/models/academy.dart';
import 'package:sibaha_app/data/services/academy_service.dart';

import '../../fixtures/academy_fixtures.dart';

class MockDio extends Mock implements Dio {}

const _token = 'test_token';

Response<dynamic> _response(dynamic data, {int statusCode = 200}) => Response(
      data: data,
      statusCode: statusCode,
      requestOptions: RequestOptions(path: ''),
    );

DioException _dioError(int statusCode) => DioException(
      requestOptions: RequestOptions(path: ''),
      response: Response(
        statusCode: statusCode,
        data: {'detail': 'error'},
        requestOptions: RequestOptions(path: ''),
      ),
      type: DioExceptionType.badResponse,
    );

void main() {
  late MockDio dio;
  late AcademyService service;

  setUpAll(() {
    registerFallbackValue(Uri.parse(''));
    registerFallbackValue(Options());
  });

  setUp(() {
    dio = MockDio();
    service = AcademyService(dio);
  });

  group('fetchAcademies', () {
    test('succès — retourne une liste d\'academies', () async {
      when(() => dio.getUri<dynamic>(any(), options: any(named: 'options')))
          .thenAnswer((_) async => _response({
                'data': [academyJson(id: 1), academyJson(id: 2)],
              }));

      final result = await service.fetchAcademies(_token);

      expect(result, isA<List<Academy>>());
      expect(result.length, 2);
      expect(result.first.name, 'Academy 1');
      expect(result.last.id, 2);
    });

    test('401 — lève TokenExpiredException', () async {
      when(() => dio.getUri<dynamic>(any(), options: any(named: 'options')))
          .thenThrow(_dioError(401));

      await expectLater(
        service.fetchAcademies(_token),
        throwsA(isA<TokenExpiredException>()),
      );
    });

    test('404 — lève ServerException avec statusCode 404', () async {
      when(() => dio.getUri<dynamic>(any(), options: any(named: 'options')))
          .thenThrow(_dioError(404));

      await expectLater(
        service.fetchAcademies(_token),
        throwsA(
          isA<ServerException>().having((e) => e.statusCode, 'statusCode', 404),
        ),
      );
    });
  });

  group('fetchAcademyDetails', () {
    const academyId = 42;

    test('succès — retourne l\'academy correspondante', () async {
      when(() => dio.getUri<dynamic>(any(), options: any(named: 'options')))
          .thenAnswer((_) async => _response({'data': academyJson(id: academyId)}));

      final result = await service.fetchAcademyDetails(_token, academyId);

      expect(result, isA<Academy>());
      expect(result.id, academyId);
      expect(result.city, 'Tunis');
      expect(result.specialities, containsAll(['freestyle', 'butterfly']));
    });

    test('401 — lève TokenExpiredException', () async {
      when(() => dio.getUri<dynamic>(any(), options: any(named: 'options')))
          .thenThrow(_dioError(401));

      await expectLater(
        service.fetchAcademyDetails(_token, academyId),
        throwsA(isA<TokenExpiredException>()),
      );
    });

    test('404 — lève ServerException avec statusCode 404', () async {
      when(() => dio.getUri<dynamic>(any(), options: any(named: 'options')))
          .thenThrow(_dioError(404));

      await expectLater(
        service.fetchAcademyDetails(_token, academyId),
        throwsA(
          isA<ServerException>().having((e) => e.statusCode, 'statusCode', 404),
        ),
      );
    });
  });
}
