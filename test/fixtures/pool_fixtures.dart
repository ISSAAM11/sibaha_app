import 'package:sibaha_app/data/models/pool.dart';

Map<String, dynamic> poolJson({int id = 1}) => {
      'id': id,
      'name': 'Pool $id',
      'academy_name': 'Academy Test',
      'academy_id': 1,
      'speciality': ['freestyle', 'backstroke'],
      'dimension': ['25m', '6 lanes'],
      'heated': true,
      'showers': 4,
      'image': null,
      'created_at': '2024-01-01T00:00:00Z',
    };

Pool fakePool({int id = 1}) => Pool.fromJson(poolJson(id: id));
