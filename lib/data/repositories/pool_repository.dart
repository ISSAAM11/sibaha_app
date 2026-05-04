import 'package:sibaha_app/data/models/pool.dart';
import 'package:sibaha_app/data/services/pool_service.dart';

class PoolRepository {
  final PoolService _service;

  PoolRepository(this._service);

  Future<List<Pool>> getPools(String? token) => _service.fetchPools(token);

  Future<Pool> getPoolDetails(String? token, int id) =>
      _service.fetchPoolDetails(token, id);
}
