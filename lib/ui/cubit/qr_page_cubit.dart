import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management/data/repo/inventorydao_repository.dart';
import 'package:inventory_management/ui/views/qr_state.dart';

class QrPageCubit extends Cubit<QrState> {
  final InventoryDaoRepository repo;

  QrPageCubit(this.repo) : super(QrInitial());

  Future<void> getProductByQr(String? qrValue) async {
    emit(QrLoading());

    if (qrValue == null || qrValue.isEmpty) {
      emit(QrError("QR Kod Okunamadı!"));
      return;
    }

    final int? id = int.tryParse(qrValue);

    if (id == null) {
      emit(QrError("Geçersiz QR Kod"));
      return;
    }

    final product = await repo.getProductById(id);

    if (product == null) {
      emit(QrError("Ürün Bulunamadı"));
    } else {
      emit(QrSuccess(product));
    }
  }
}
