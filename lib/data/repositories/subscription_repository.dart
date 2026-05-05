import 'package:sibaha_app/data/models/academy_client.dart';
import 'package:sibaha_app/data/models/subscription.dart';
import 'package:sibaha_app/data/services/subscription_service.dart';

class SubscriptionRepository {
  final SubscriptionService _service;

  SubscriptionRepository(this._service);

  Future<Subscription> subscribe(String token, int academyId) =>
      _service.subscribe(token, academyId);

  Future<List<Subscription>> getMySubscriptions(String token) =>
      _service.fetchMySubscriptions(token);

  Future<List<AcademyClient>> getAcademyClients(String token, int academyId) =>
      _service.fetchAcademyClients(token, academyId);

  Future<void> removeClient(String token, int academyId, int subscriptionId) =>
      _service.removeClient(token, academyId, subscriptionId);
}
