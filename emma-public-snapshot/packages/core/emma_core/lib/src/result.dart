class Result<T> {
  const Result._({this.data, this.error});

  final T? data;
  final Object? error;

  bool get isSuccess => error == null;
  bool get isFailure => !isSuccess;

  static Result<T> success<T>(T data) {
    return Result<T>._(data: data);
  }

  static Result<T> failure<T>(Object error) {
    return Result<T>._(error: error);
  }
}
