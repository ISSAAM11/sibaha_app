import 'dart:typed_data';

import 'package:sibaha_app/data/models/pool.dart';
import 'package:sibaha_app/data/services/pool_service.dart';

class PoolRepository {
  final PoolService _service;

  PoolRepository(this._service);

  Future<List<Pool>> getPools(String? token) => _service.fetchPools(token);

  Future<Pool> getPoolDetails(String? token, int id) =>
      _service.fetchPoolDetails(token, id);

  Future<Pool> updatePool({
    required String token,
    required int academyId,
    required int poolId,
    required String name,
    required List<String> speciality,
    required List<String> dimension,
    required bool heated,
    required int showers,
    Uint8List? pictureBytes,
    String? pictureFilename,
  }) =>
      _service.updatePool(
        token: token,
        academyId: academyId,
        poolId: poolId,
        name: name,
        speciality: speciality,
        dimension: dimension,
        heated: heated,
        showers: showers,
        pictureBytes: pictureBytes,
        pictureFilename: pictureFilename,
      );

  Future<void> deletePool({
    required String token,
    required int academyId,
    required int poolId,
  }) =>
      _service.deletePool(token: token, academyId: academyId, poolId: poolId);

  Future<Pool> createPool({
    required String token,
    required int academyId,
    required String name,
    required List<String> speciality,
    required List<String> dimension,
    required bool heated,
    required int showers,
    Uint8List? pictureBytes,
    String? pictureFilename,
  }) =>
      _service.createPool(
        token: token,
        academyId: academyId,
        name: name,
        speciality: speciality,
        dimension: dimension,
        heated: heated,
        showers: showers,
        pictureBytes: pictureBytes,
        pictureFilename: pictureFilename,
      );
}
