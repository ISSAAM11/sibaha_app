import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sibaha_app/service/auth_service.dart';

part 'token_event.dart';
part 'token_state.dart';

class TokenBloc extends Bloc<TokenEvent, TokenState> {
  final AuthService authService = AuthService();

  TokenBloc() : super(TokenInitial()) {
    on<TokenFetch>(
      (event, emit) async {
        final (token, userName) = await authService.retrieveToken();
        if (token != null && userName != null) {
          emit(TokenRetrieved(token, userName));
        } else {
          emit(TokenNotFound());
        }
      },
    );
  }
}
