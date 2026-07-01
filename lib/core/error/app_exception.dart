/// A user-presentable failure. ViewModels surface these; views show the message.
class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => message;
}
