import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import '../local/boxes/box_names.dart';
import '../../features/home/data/models/transaction_model.dart';
import '../../features/home/data/models/category_model.dart';
import '../models/app_settings.dart';

class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();
    // Get application directory
    final appDocumentDir = await getApplicationDocumentsDirectory();
    
    // Initialize Hive
    await Hive.initFlutter(appDocumentDir.path);
    
    // Register adapters
    Hive.registerAdapter(TransactionModelAdapter());
    Hive.registerAdapter(CategoryModelAdapter());
    Hive.registerAdapter(AppSettingsAdapter());
    
    // Open boxes
    await Future.wait([
      openBoxSafely(BoxNames.transactions),
      openBoxSafely(BoxNames.categories),
      openBoxSafely(BoxNames.goals),
      openBoxSafely(BoxNames.settings),
    ]);
  }

  static Future<Box<T>> openBoxSafely<T>(String name) async {
    if (Hive.isBoxOpen(name)) {
      return Hive.box<T>(name);
    }
    return await Hive.openBox<T>(name);
  }
  static Box<T> getBox<T>(String name) => Hive.box<T>(name);
  
  static Future<void> openBoxes() async {
    await Hive.openBox(BoxNames.transactions);
    await Hive.openBox(BoxNames.categories);
    await Hive.openBox(BoxNames.goals);
    await Hive.openBox(BoxNames.settings);
  }

  static Future<void> closeBoxes() async {
    await Hive.box(BoxNames.transactions).close();
    await Hive.box(BoxNames.categories).close();
    await Hive.box(BoxNames.goals).close();
    await Hive.box(BoxNames.settings).close();
  }

  static Future<void> clearAllData() async {
    await Hive.box(BoxNames.transactions).clear();
    await Hive.box(BoxNames.categories).clear();
    await Hive.box(BoxNames.goals).clear();
    await Hive.box(BoxNames.settings).clear();
  }
}
