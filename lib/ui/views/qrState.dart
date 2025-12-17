import 'package:inventory_management/data/entity/products.dart';

abstract class QrState {}

class QrInitial extends QrState {}

class QrSuccess extends QrState {
  final Products product;
  QrSuccess(this.product);
}

class QrError extends QrState {
  final String message;
  QrError(this.message);
}
