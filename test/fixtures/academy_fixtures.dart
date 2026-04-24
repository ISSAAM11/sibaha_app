import 'package:sibaha_app/data/models/academy.dart';

Map<String, dynamic> academyJson({int id = 1}) => {
      'id': id,
      'name': 'Academy $id',
      'city': 'Tunis',
      'address': '10 rue Test',
      'specialities': ['freestyle', 'butterfly'],
      'description': 'Test academy',
      'pool_list': [
        {'id': 1, 'name': 'Pool A', 'image': null}
      ],
      'created_at': '2024-01-01T00:00:00Z',
      'updated_at': '2024-01-01T00:00:00Z',
      'weekday_availabilities': [],
      'image': null,
    };

Academy fakeAcademy({int id = 1}) => Academy.fromJson(academyJson(id: id));
