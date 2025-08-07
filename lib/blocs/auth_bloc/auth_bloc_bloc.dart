import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sibaha_app/service/auth_service.dart';

part 'auth_bloc_event.dart';
part 'auth_bloc_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService = AuthService();
  AuthBloc() : super(AuthInitial()) {
    on<LoginEvent>((event, emit) async {
      try {
        await authService.login(event.email, event.password);
        emit(AuthSuccess());
      } catch (error) {
        emit(AuthFailed(error.toString()));
      }
    });

    on<AutoAuthEvent>((event, emit) async {
      final user = await authService.tryAutoLogin();
      if (user == null) {
        emit(AuthLogout());
      } else {
        emit(AuthSuccess());
      }
    });

    on<LogoutEvent>((event, emit) async {
      await authService.logoutUser();
      emit(AuthLogout());
    });

    on<ResetAuthEvent>((event, emit) async {
      emit(AuthInitial());
    });
  }
}
