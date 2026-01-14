import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management/data/entity/categories.dart';
import 'package:inventory_management/data/repo/inventorydao_repository.dart';

class AddProductPageCubit extends Cubit<List<Categories>> {
  AddProductPageCubit() : super(<Categories>[]);

  var irepo = InventoryDaoRepository();

  Future<void> loadCategory() async {
    var list = await irepo.loadCategories();
    emit(list);
  }

  Future<void> save(String name, int stock, int category_id) async {
    await irepo.save(name, stock, category_id);
  }
}
