import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sibaha_app/data/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthInitial()) {
    on<LoginEvent>((event, emit) async {
      try {
        await _authRepository.login(event.email, event.password);
        emit(AuthSuccess());
      } catch (error) {
        emit(AuthFailed(error.toString()));
      }
    });

    on<AutoAuthEvent>((event, emit) async {
      final user = await _authRepository.tryAutoLogin();
      if (user == null) {
        emit(AuthLogout());
      } else {
        emit(AuthSuccess());
      }
    });

    on<LogoutEvent>((event, emit) async {
      await _authRepository.logout();
      emit(AuthLogout());
    });

    on<ResetAuthEvent>((event, emit) async {
      emit(AuthInitial());
    });
  }
}
