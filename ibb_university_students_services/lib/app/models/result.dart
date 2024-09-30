class Result<T> {
  final T? data;
  final int? statusCode;
  final bool? hasError;
  final String? message;

  Result({
    this.data,
    this.statusCode,
    this.hasError,
    this.message,

  });
}
