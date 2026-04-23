import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sibaha_app/presentation/blocs/academy_bloc/academy_bloc.dart';
import 'package:sibaha_app/presentation/blocs/token_bloc/token_bloc.dart';
import 'package:sibaha_app/presentation/widgets/academies/academy_card.dart';

class AcademiesListWidget extends StatefulWidget {
  const AcademiesListWidget({super.key});

  @override
  State<AcademiesListWidget> createState() => _AcademiesListWidgetState();
}

class _AcademiesListWidgetState extends State<AcademiesListWidget> {
  bool _fetchTriggered = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_fetchTriggered) {
      final token =
          (context.read<TokenBloc>().state as TokenRetrieved).token;
      context.read<AcademyBloc>().add(FetchAcademies(token));
      _fetchTriggered = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AcademyBloc, AcademyState>(
      listenWhen: (_, s) => s is AcademyTokenExpired,
      listener: (context, _) {
        context.read<TokenBloc>().add(TokenRefresh());
      },
      child: Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.filter_list,
                            size: 18, color: Colors.black87),
                        const SizedBox(width: 8),
                        const Text('Filter',
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.location_on,
                            size: 18, color: Colors.black87),
                        const SizedBox(width: 8),
                        const Text('Map',
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: BlocBuilder<AcademyBloc, AcademyState>(
            builder: (context, state) {
              if (state is AcademyInitial ||
                  state is AcademyLoading ||
                  state is AcademyTokenExpired) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is AcademyFailed) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text(state.message),
                  ),
                );
              }
              if (state is AcademyLoaded) {
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.academies.length,
                  itemBuilder: (context, index) {
                    return AcademyCard(
                      index: index,
                      academy: state.academies[index],
                    );
                  },
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ],
      ),
    );
  }
}
