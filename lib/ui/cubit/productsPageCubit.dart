import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management/data/entity/products.dart';
import 'package:inventory_management/data/repo/inventorydao_repository.dart';

class ProductsPageCubit extends Cubit<List<Products>>{
  ProductsPageCubit():super(<Products>[]);

  var irepo = InventoryDaoRepository();

  Future<void> loadProducts() async{
    var list = await irepo.loadProducts();
    emit(list);
  }

  Future<void> search(String searchResult) async{
    var list = await irepo.search(searchResult);
    emit(list);
  }

  Future<void> delete(int id) async{
    await irepo.delete(id);
    await loadProducts();
  }
}