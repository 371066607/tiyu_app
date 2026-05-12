import 'package:get_storage/get_storage.dart';

import '../../domain/repositories/favorites_repository.dart';

class LocalFavoritesRepository implements FavoritesRepository {
  LocalFavoritesRepository(this.storage);

  static const _favoriteMatchesKey = 'favorite_match_ids';

  final GetStorage storage;

  @override
  Future<Set<String>> loadFavoriteMatchIds() async {
    final raw = storage.read<List<dynamic>>(_favoriteMatchesKey) ?? <dynamic>[];
    return raw.map((item) => item.toString()).toSet();
  }

  @override
  Future<void> saveFavoriteMatchIds(Set<String> ids) async {
    await storage.write(_favoriteMatchesKey, ids.toList()..sort());
  }
}
