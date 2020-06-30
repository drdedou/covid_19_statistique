class CustemException implements Exception {
  final messageError;
  CustemException({this.messageError});
  @override
  String toString() {
    return messageError;
  }
}
