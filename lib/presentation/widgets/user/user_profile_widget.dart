import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sibaha_app/presentation/blocs/token_bloc/token_bloc.dart';
import 'package:sibaha_app/presentation/blocs/user_details_bloc/user_details_bloc.dart';
import 'package:sibaha_app/presentation/widgets/user/user_details_widget.dart';
import 'package:sibaha_app/presentation/widgets/user/user_email_edit_widget.dart';
import 'package:sibaha_app/presentation/widgets/user/user_informations_widget.dart';
import 'package:sibaha_app/presentation/widgets/user/user_password_edit_widget.dart';

class UserProfileWidget extends StatefulWidget {
  final String interface;

  const UserProfileWidget(this.interface, {super.key});

  @override
  State<UserProfileWidget> createState() => _UserProfileWidgetState();
}

class _UserProfileWidgetState extends State<UserProfileWidget> {
  bool _fetchTriggered = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_fetchTriggered) {
      final token = (context.read<TokenBloc>().state as TokenRetrieved).token;
      context.read<UserDetailsBloc>().add(FetchUserEvent(token));
      _fetchTriggered = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F8),
      body: SafeArea(
        child: BlocListener<UserDetailsBloc, UserDetailsState>(
          listenWhen: (_, s) => s is UserDetailsTokenExpired,
          listener: (context, _) {
            context.read<TokenBloc>().add(TokenRefresh());
            context.read<UserDetailsBloc>().add(UserDetailsReset());
          },
          child: BlocBuilder<UserDetailsBloc, UserDetailsState>(
            builder: (context, state) {
              return Column(
                children: [
                  if (widget.interface != "informations")
                    Align(
                      alignment: Alignment.topLeft,
                      child: BackButton(
                        onPressed: () =>
                            context.go('/UserDetails/informations'),
                        color: const Color(0xFF0058BC),
                      ),
                    ),
                  _buildProfileHeader(state),
                  switch (widget.interface) {
                    "informations" => const UserInformationsWidget(),
                    "details" => const UserDetailsWidget(),
                    "email" => const UserEmailEditWidget(),
                    "password" => const UserPasswordEditWidget(),
                    _ => const SizedBox.shrink(),
                  },
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(UserDetailsState state) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 24, 12, 12),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -48,
            left: -48,
            child: Container(
              width: 256,
              height: 256,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF0058BC).withOpacity(0.12),
                    const Color(0xFF0058BC).withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              children: [
                _buildAvatar(state),
                if (state is UserDetailsLoaded) ...[
                  Text(
                    state.data.username,
                    style: const TextStyle(
                      fontFamily: 'Lexend',
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1C1B1B),
                      letterSpacing: -0.32,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDBE4EA),
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    child: Text(
                      _formatUserType(
                          state.data.userType.toString().split('.').last),
                      style: const TextStyle(
                        fontFamily: 'Lexend',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF141D21),
                      ),
                    ),
                  ),
                ] else if (state is UserDetailsLoading ||
                    state is UserDetailsInitial) ...[
                  const SizedBox(height: 66),
                ] else if (state is UserDetailsError) ...[
                  Text(state.message,
                      style: const TextStyle(color: Colors.red)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(UserDetailsState state) {
    String? pictureUrl;
    if (state is UserDetailsLoaded) {
      pictureUrl = state.data.picture;
    }

    return Stack(
      children: [
        Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipOval(
            child: state is UserDetailsLoading ||
                    state is UserDetailsInitial ||
                    state is UserDetailsTokenExpired ||
                    state is UploadPictureLoading
                ? const ColoredBox(
                    color: Color(0xFFE5E2E1),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : pictureUrl != null
                    ? Image.network(
                        pictureUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _defaultAvatarContent(),
                      )
                    : _defaultAvatarContent(),
          ),
        ),
        Positioned(
          bottom: 4,
          right: 4,
          child: GestureDetector(
            onTap: () => _pickAndUploadImage(context),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFF0058BC),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(Icons.edit, color: Colors.white, size: 18),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _pickAndUploadImage(BuildContext context) async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (image == null) return;
    if (!context.mounted) return;
    final token = (context.read<TokenBloc>().state as TokenRetrieved).token;
    context
        .read<UserDetailsBloc>()
        .add(UploadProfilePictureEvent(token, image));
  }

  Widget _defaultAvatarContent() {
    return const ColoredBox(
      color: Color(0xFFE5E2E1),
      child: Icon(Icons.person, size: 70, color: Color(0xFF717786)),
    );
  }

  String _formatUserType(String type) {
    switch (type) {
      case 'academyOwner':
        return 'Academy Owner';
      case 'coach':
        return 'Coach';
      default:
        return 'Swimmer';
    }
  }
}
