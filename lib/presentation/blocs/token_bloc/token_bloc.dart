import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sibaha_app/data/repositories/auth_repository.dart';

part 'token_event.dart';
part 'token_state.dart';

class TokenBloc extends Bloc<TokenEvent, TokenState> {
  final AuthRepository _authRepository;

  TokenBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(TokenInitial()) {
    on<TokenFetch>(_onFetchToken);
    on<TokenRefresh>(_onRefreshToken);
    on<TokenDelete>((event, emit) => emit(TokenNotFound()));
  }

  Future<void> _onFetchToken(TokenFetch event, Emitter<TokenState> emit) async {
    final (token, username, userType) = await _authRepository.retrieveToken();

    if (token != null && username != null && userType != null) {
      emit(TokenRetrieved(token, username, userType));
    } else {
      emit(TokenNotFound());
    }
  }

  Future<void> _onRefreshToken(
      TokenRefresh event, Emitter<TokenState> emit) async {
    emit(TokenExpired());
    final (token, username, userType) = await _authRepository.refreshToken();

    if (token != null && username != null && userType != null) {
      emit(TokenRetrieved(token, username, userType));
    } else {
      emit(TokenNotFound());
    }
  }
}
