import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:sibaha_app/core/exceptions/app_exceptions.dart';
import 'package:sibaha_app/data/models/user.dart';
import 'package:sibaha_app/data/repositories/user_repository.dart';

part 'user_details_event.dart';
part 'user_details_state.dart';

class UserDetailsBloc extends Bloc<UserDetailsEvent, UserDetailsState> {
  final UserRepository _userRepository;
  User? user;

  UserDetailsBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(UserDetailsInitial()) {
    on<FetchUserEvent>(_onFetchUser);
    on<UserDetailsReset>(_onUserDetailsReset);
    on<UploadProfilePictureEvent>(_onUploadProfilePicture);
    on<UpdateProfileEvent>(_onUpdateProfile);
    on<ChangePasswordEvent>(_onChangePassword);
  }

  Future<void> _onFetchUser(
      FetchUserEvent event, Emitter<UserDetailsState> emit) async {
    emit(UserDetailsLoading());
    try {
      user = await _userRepository.getUserDetails(event.token);
      emit(UserDetailsLoaded(user!));
    } on TokenExpiredException catch (_) {
      emit(UserDetailsTokenExpired());
    } catch (e) {
      emit(UserDetailsError('Failed to fetch user: $e'));
    }
  }

  Future<void> _onUserDetailsReset(
      UserDetailsReset event, Emitter<UserDetailsState> emit) async {
    user = null;
    emit(UserDetailsInitial());
  }

  Future<void> _onUploadProfilePicture(
      UploadProfilePictureEvent event, Emitter<UserDetailsState> emit) async {
    emit(UploadPictureLoading());
    try {
      user = await _userRepository.uploadProfilePicture(
          event.token, event.imageFile);
      emit(UserDetailsLoaded(user!));
    } on TokenExpiredException catch (_) {
      emit(UserDetailsTokenExpired());
    } catch (e) {
      emit(UserDetailsError(e.toString()));
    }
  }

  Future<void> _onUpdateProfile(
      UpdateProfileEvent event, Emitter<UserDetailsState> emit) async {
    emit(UpdateProfileLoading());
    try {
      user = await _userRepository.updateProfile(
        event.token,
        username: event.username,
        phone: event.phone,
      );
      emit(UpdateProfileSuccess());
      emit(UserDetailsLoaded(user!));
    } on TokenExpiredException catch (_) {
      emit(UserDetailsTokenExpired());
    } catch (e) {
      emit(UpdateProfileError(e.toString()));
    }
  }

  Future<void> _onChangePassword(
      ChangePasswordEvent event, Emitter<UserDetailsState> emit) async {
    emit(ChangePasswordLoading());
    try {
      await _userRepository.changePassword(
          event.token, event.currentPassword, event.newPassword);
      emit(ChangePasswordSuccess());
    } on TokenExpiredException catch (_) {
      emit(UserDetailsTokenExpired());
    } catch (e) {
      emit(ChangePasswordError(e.toString()));
    }
  }
}
