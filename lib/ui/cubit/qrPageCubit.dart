import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management/data/repo/inventorydao_repository.dart';
import 'package:inventory_management/ui/views/qrState.dart';

class QrPageCubit extends Cubit<QrState> {
  final InventoryDaoRepository repo;

  QrPageCubit(this.repo) : super(QrInitial());

  Future<void> getProductById(int id) async {
    try {
      final product = await repo.getProductById(id);
      emit(QrSuccess(product));
    } catch (e) {
      emit(QrError("Ürün bulunamadı"));
    }
  }
}
