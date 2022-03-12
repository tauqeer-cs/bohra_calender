import 'package:objectbox/objectbox.dart';
import 'package:path_provider/path_provider.dart';

import '../objectbox.g.dart';

class _ObjectBoxService {
  late Store store;

  Future<void> initialize() async {
    final appDocDir = await getApplicationDocumentsDirectory();
      store = await openStore(directory: appDocDir.path);
      print('object');
      
  }
}

final objectBoxService = _ObjectBoxService();
