import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sibaha_app/presentation/blocs/pool_bloc/pool_bloc.dart';
import 'package:sibaha_app/presentation/blocs/token_bloc/token_bloc.dart';
import 'package:sibaha_app/presentation/widgets/pools/pool_card.dart';

class PoolsListWidget extends StatefulWidget {
  const PoolsListWidget({super.key});

  @override
  State<PoolsListWidget> createState() => _PoolsListWidgetState();
}

class _PoolsListWidgetState extends State<PoolsListWidget> {
  bool _fetchTriggered = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_fetchTriggered) {
      final token = (context.read<TokenBloc>().state as TokenRetrieved).token;
      context.read<PoolBloc>().add(FetchPools(token));
      _fetchTriggered = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PoolBloc, PoolState>(
      listenWhen: (_, s) => s is PoolTokenExpired,
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
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.filter_list,
                              size: 18, color: Colors.black87),
                          SizedBox(width: 8),
                          Text('Filter',
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
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.location_on,
                              size: 18, color: Colors.black87),
                          SizedBox(width: 8),
                          Text('Map',
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
            child: BlocBuilder<PoolBloc, PoolState>(
              builder: (context, state) {
                if (state is PoolInitial ||
                    state is PoolLoading ||
                    state is PoolTokenExpired) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is PoolFailed) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Text(state.message),
                    ),
                  );
                }
                if (state is PoolLoaded) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.pools.length,
                    itemBuilder: (context, index) {
                      return PoolCard(pool: state.pools[index]);
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
