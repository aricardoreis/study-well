abstract class BaseService<T> {
  Future<List<T>> getAll();
  Future<bool> insert(T name);
  void update(String id, String name);
  void delete(String id);
}
