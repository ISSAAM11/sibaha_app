import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sibaha_app/core/exceptions/app_exceptions.dart';
import 'package:sibaha_app/data/models/academy.dart';
import 'package:sibaha_app/data/repositories/academy_repository.dart';
import 'package:sibaha_app/presentation/blocs/academy_bloc/academy_bloc.dart';
import '../../fixtures/academy_fixtures.dart';

class MockAcademyRepository extends Mock implements AcademyRepository {}

void main() {
  late AcademyBloc academyBloc;
  late MockAcademyRepository mockAcademyRepository;

  setUp(() {
    mockAcademyRepository = MockAcademyRepository();
    academyBloc = AcademyBloc(academyRepository: mockAcademyRepository);
  });

  tearDown(() {
    academyBloc.close();
  });

  group('AcademyBloc', () {
    const testToken = 'test-token-123';
    const errorMessage = 'Server unavailable';
    final testAcademies = [fakeAcademy(id: 1), fakeAcademy(id: 2)];

    test('initial state is AcademyInitial', () {
      expect(academyBloc.state, equals(AcademyInitial()));
    });

    group('FetchAcademies', () {
      blocTest<AcademyBloc, AcademyState>(
        'emits [AcademyLoading, AcademyLoaded] when fetch is successful',
        build: () {
          when(() => mockAcademyRepository.getAcademies(testToken))
              .thenAnswer((_) async => testAcademies);
          return academyBloc;
        },
        act: (bloc) => bloc.add(FetchAcademies(testToken)),
        expect: () => [
          AcademyLoading(),
          AcademyLoaded(testAcademies),
        ],
        verify: (_) {
          verify(() => mockAcademyRepository.getAcademies(testToken)).called(1);
        },
      );

      blocTest<AcademyBloc, AcademyState>(
        'emits [AcademyLoading, AcademyTokenExpired] when token is expired',
        build: () {
          when(() => mockAcademyRepository.getAcademies(testToken))
              .thenThrow(TokenExpiredException('Token expired'));
          return academyBloc;
        },
        act: (bloc) => bloc.add(FetchAcademies(testToken)),
        expect: () => [
          AcademyLoading(),
          isA<AcademyTokenExpired>(),
        ],
      );

      blocTest<AcademyBloc, AcademyState>(
        'emits [AcademyLoading, AcademyFailed] when fetch fails with generic error',
        build: () {
          const errorMessage = 'Server unavailable';
          when(() => mockAcademyRepository.getAcademies(testToken))
              .thenThrow(Exception(errorMessage));
          return academyBloc;
        },
        act: (bloc) => bloc.add(FetchAcademies(testToken)),
        expect: () => [
          AcademyLoading(),
          isA<AcademyFailed>().having(
            (state) => state.message,
            'message',
            contains(errorMessage),
          ),
        ],
      );

      blocTest<AcademyBloc, AcademyState>(
        'returns empty list when no academies exist',
        build: () {
          when(() => mockAcademyRepository.getAcademies(testToken))
              .thenAnswer((_) async => <Academy>[]);
          return academyBloc;
        },
        act: (bloc) => bloc.add(FetchAcademies(testToken)),
        expect: () => [
          AcademyLoading(),
          AcademyLoaded(<Academy>[]),
        ],
      );
    });
  });
}
