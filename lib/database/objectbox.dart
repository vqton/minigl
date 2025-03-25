import 'package:minigl/objectbox.g.dart';


class ObjectBox {
  late final Store store;

  static ObjectBox? _instance;

  ObjectBox._create(this.store);

  /// Initialize ObjectBox and provide a singleton instance.
  static Future<ObjectBox> init() async {
    if (_instance == null) {
      final store = await openStore(); // Open the ObjectBox database
      _instance = ObjectBox._create(store);
    }
    return _instance!;
  }

  /// Get instance of ObjectBox
  static ObjectBox get instance {
    if (_instance == null) {
      throw Exception("ObjectBox is not initialized. Call `ObjectBox.init()` first.");
    }
    return _instance!;
  }

  /// Get a Box<T> for a specific entity
  Box<T> getBox<T>() => store.box<T>();
}
