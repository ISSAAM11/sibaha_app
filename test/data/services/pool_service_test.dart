import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sibaha_app/core/exceptions/app_exceptions.dart';
import 'package:sibaha_app/data/models/pool.dart';
import 'package:sibaha_app/data/services/pool_service.dart';

import '../../fixtures/pool_fixtures.dart';

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
  late PoolService service;

  setUpAll(() {
    registerFallbackValue(Uri.parse(''));
    registerFallbackValue(Options());
  });

  setUp(() {
    dio = MockDio();
    service = PoolService(dio);
  });

  group('fetchPools', () {
    test('succès — retourne une liste de pools', () async {
      when(() => dio.getUri<dynamic>(any(), options: any(named: 'options')))
          .thenAnswer((_) async => _response({
                'data': [poolJson(id: 1), poolJson(id: 2)],
              }));

      final result = await service.fetchPools(_token);

      expect(result, isA<List<Pool>>());
      expect(result.length, 2);
      expect(result.first.name, 'Pool 1');
      expect(result.last.id, 2);
    });

    test('401 — lève TokenExpiredException', () async {
      when(() => dio.getUri<dynamic>(any(), options: any(named: 'options')))
          .thenThrow(_dioError(401));

      await expectLater(
        service.fetchPools(_token),
        throwsA(isA<TokenExpiredException>()),
      );
    });

    test('404 — lève ServerException avec statusCode 404', () async {
      when(() => dio.getUri<dynamic>(any(), options: any(named: 'options')))
          .thenThrow(_dioError(404));

      await expectLater(
        service.fetchPools(_token),
        throwsA(
          isA<ServerException>().having((e) => e.statusCode, 'statusCode', 404),
        ),
      );
    });
  });

  group('fetchPoolDetails', () {
    const poolId = 10;

    test('succès — retourne le pool correspondant', () async {
      when(() => dio.getUri<dynamic>(any(), options: any(named: 'options')))
          .thenAnswer((_) async => _response({'data': poolJson(id: poolId)}));

      final result = await service.fetchPoolDetails(_token, poolId);

      expect(result, isA<Pool>());
      expect(result.id, poolId);
      expect(result.heated, true);
      expect(result.speciality, containsAll(['freestyle', 'backstroke']));
    });

    test('401 — lève TokenExpiredException', () async {
      when(() => dio.getUri<dynamic>(any(), options: any(named: 'options')))
          .thenThrow(_dioError(401));

      await expectLater(
        service.fetchPoolDetails(_token, poolId),
        throwsA(isA<TokenExpiredException>()),
      );
    });

    test('404 — lève ServerException avec statusCode 404', () async {
      when(() => dio.getUri<dynamic>(any(), options: any(named: 'options')))
          .thenThrow(_dioError(404));

      await expectLater(
        service.fetchPoolDetails(_token, poolId),
        throwsA(
          isA<ServerException>().having((e) => e.statusCode, 'statusCode', 404),
        ),
      );
    });
  });
}
