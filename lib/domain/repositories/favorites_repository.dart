abstract class FavoritesRepository {
  Future<Set<String>> loadFavoriteMatchIds();

  Future<void> saveFavoriteMatchIds(Set<String> ids);
}
