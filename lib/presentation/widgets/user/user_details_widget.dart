import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sibaha_app/presentation/blocs/token_bloc/token_bloc.dart';
import 'package:sibaha_app/presentation/blocs/user_details_bloc/user_details_bloc.dart';

class UserDetailsWidget extends StatefulWidget {
  const UserDetailsWidget({super.key});

  @override
  State<UserDetailsWidget> createState() => _UserDetailsWidgetState();
}

class _UserDetailsWidgetState extends State<UserDetailsWidget> {
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _initialized = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _prefill(UserDetailsLoaded state) {
    if (!_initialized) {
      _usernameController.text = state.data.username;
      _phoneController.text = state.data.phone;
      _initialized = true;
    }
  }

  void _submit() {
    final token = (context.read<TokenBloc>().state as TokenRetrieved).token;
    context.read<UserDetailsBloc>().add(
          UpdateProfileEvent(
            token,
            username: _usernameController.text.trim(),
            phone: _phoneController.text.trim(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocListener<UserDetailsBloc, UserDetailsState>(
        listenWhen: (_, s) =>
            s is UpdateProfileSuccess || s is UpdateProfileError,
        listener: (context, state) {
          if (state is UpdateProfileSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile updated successfully.'),
                backgroundColor: Color(0xFF00696F),
              ),
            );
          } else if (state is UpdateProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: const Color(0xFFBA1A1A),
              ),
            );
          }
        },
        child: BlocBuilder<UserDetailsBloc, UserDetailsState>(
          builder: (context, state) {
            if (state is UserDetailsInitial || state is UserDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is UserDetailsError) {
              return Center(
                child: Text(state.message,
                    style: const TextStyle(color: Color(0xFFBA1A1A))),
              );
            }
            if (state is UserDetailsLoaded) {
              _prefill(state);
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Personal Information',
                    style: TextStyle(
                      fontFamily: 'Lexend',
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1C1B1B),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFFF0EDEC)),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Column(
                      children: [
                        _buildField(
                          label: 'Username',
                          controller: _usernameController,
                          icon: Icons.person_outline,
                        ),
                        const Divider(height: 1, color: Color(0xFFF0EDEC)),
                        _buildField(
                          label: 'Phone',
                          controller: _phoneController,
                          icon: Icons.phone,
                          keyboardType: TextInputType.phone,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  BlocBuilder<UserDetailsBloc, UserDetailsState>(
                    buildWhen: (_, s) =>
                        s is UpdateProfileLoading ||
                        s is UpdateProfileSuccess ||
                        s is UpdateProfileError ||
                        s is UserDetailsLoaded,
                    builder: (context, state) {
                      final isLoading = state is UpdateProfileLoading;
                      return SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0058BC),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Save Changes',
                                  style: TextStyle(
                                    fontFamily: 'Lexend',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFF0EDEC),
            ),
            child: Icon(icon, color: const Color(0xFF414755), size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontFamily: 'Lexend',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF414755),
                  ),
                ),
                const SizedBox(height: 4),
                TextField(
                  controller: controller,
                  keyboardType: keyboardType,
                  style: const TextStyle(
                    fontFamily: 'Lexend',
                    fontSize: 16,
                    color: Color(0xFF1C1B1B),
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    hintStyle: TextStyle(color: Colors.grey[400]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
