import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management/data/repo/inventorydao_repository.dart';

class DetailPageCubit extends Cubit<void> {
  DetailPageCubit() : super(0);

  var irepo = InventoryDaoRepository();

  Future<void> delete(int id) async {
    await irepo.delete(id);
  }
}
