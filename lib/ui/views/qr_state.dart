abstract class QrState {}

class QrInitial extends QrState {}

class QrLoading extends QrState {}

class QrSuccess extends QrState {
  final dynamic product;
  QrSuccess(this.product);
}

class QrError extends QrState {
  final String message;
  QrError(this.message);
}