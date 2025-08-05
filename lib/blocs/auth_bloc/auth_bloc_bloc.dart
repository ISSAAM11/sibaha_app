import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sibaha_app/service/auth_service.dart';

part 'auth_bloc_event.dart';
part 'auth_bloc_state.dart';

class AuthBlocBloc extends Bloc<AuthBlocEvent, AuthBlocState> {
  final AuthService authService = AuthService();
  String token = "";
  AuthBlocBloc() : super(AuthBlocInitial()) {
    on<LoginEvent>((event, emit) async {
      if (event.email.isNotEmpty && event.password.isNotEmpty) {
        token = await authService.login(event.email, event.password);

        emit(AuthSuccess());
      } else {
        emit(AuthFailed());
      }
    });
  }
}
