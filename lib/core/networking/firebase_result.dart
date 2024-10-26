
import 'firebase_error_model.dart';

class FireBaseResult<T> {
  final T? data;
  final FirebaseErrorModel? error;

  FireBaseResult.success(this.data) : error = null;
  FireBaseResult.failure(this.error) : data = null;

  bool get isSuccess => data != null;
  bool get isFailure => error != null;
}
