import 'package:hive/hive.dart';
import '../models/supply.dart';

class SupplyRepository {
  late Box<Supply> _box;

  Future<void> init() async {
    _box = await Hive.openBox<Supply>('supplies');
  }

  Future<int> addSupply(Supply supply) async {
    return await _box.add(supply);
  }

  List<Supply> getSupplies() {
    return _box.values.toList();
  }
}