import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management/data/entity/categories.dart';
import 'package:inventory_management/data/repo/inventorydao_repository.dart';

class UpdatePageCubit extends Cubit<void>{
  UpdatePageCubit():super(0);

  var irepo = InventoryDaoRepository();

  Future<void> update(int id, String name, int stock, int categoryId) async{
    await irepo.update(id, name, stock, categoryId);
  }

  Future<List<Categories>> loadCategories() async {
    return await irepo.loadCategories();
  }
}