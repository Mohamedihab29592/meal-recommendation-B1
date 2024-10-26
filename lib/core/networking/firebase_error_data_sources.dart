import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_error_model.dart';

enum DataSource {
  INVALID_EMAIL,
  USER_NOT_FOUND,
  WRONG_PASSWORD,
  USER_DISABLED,
  OPERATION_NOT_ALLOWED,
  TOO_MANY_REQUESTS,
  WEAK_PASSWORD,
  EMAIL_ALREADY_IN_USE,
  PERMISSION_DENIED,
  UNAVAILABLE,
  DEADLINE_EXCEEDED,
  ALREADY_EXISTS,
  NOT_FOUND,
  RESOURCE_EXHAUSTED,
  FAILED_PRECONDITION,
  ABORTED,
  OUT_OF_RANGE,
  INTERNAL,
  UNIMPLEMENTED,
  DATA_LOSS,
  CANCELLED,
  UNKNOWN,
  DEFAULT,
}

class ResponseCode {
  static const int SUCCESS = 200;
  static const int INVALID_EMAIL = 1001;
  static const int USER_NOT_FOUND = 1002;
  static const int WRONG_PASSWORD = 1003;
  static const int USER_DISABLED = 1004;
  static const int OPERATION_NOT_ALLOWED = 1005;
  static const int TOO_MANY_REQUESTS = 1006;
  static const int WEAK_PASSWORD = 1007;
  static const int EMAIL_ALREADY_IN_USE = 1008;
  static const int PERMISSION_DENIED = 2001;
  static const int UNAVAILABLE = 2002;
  static const int DEADLINE_EXCEEDED = 2003;
  static const int ALREADY_EXISTS = 2004;
  static const int NOT_FOUND = 2005;
  static const int RESOURCE_EXHAUSTED = 2006;
  static const int FAILED_PRECONDITION = 2007;
  static const int ABORTED = 2008;
  static const int OUT_OF_RANGE = 2009;
  static const int INTERNAL = 2010;
  static const int UNIMPLEMENTED = 2011;
  static const int DATA_LOSS = 2012;
  static const int CANCELLED = 2013;
  static const int UNKNOWN = 2014;
  static const int DEFAULT = -1;
}

class ResponseMessage {
  static const String INVALID_EMAIL = "The email address is invalid.";
  static const String USER_NOT_FOUND = "No user found with this email.";
  static const String WRONG_PASSWORD = "The password is incorrect.";
  static const String USER_DISABLED = "The user account has been disabled.";
  static const String OPERATION_NOT_ALLOWED = "This operation is not allowed.";
  static const String TOO_MANY_REQUESTS = "Too many requests. Try again later.";
  static const String WEAK_PASSWORD = "The password is too weak.";
  static const String EMAIL_ALREADY_IN_USE = "This email is already in use.";
  static const String PERMISSION_DENIED = "You do not have permission to perform this operation.";
  static const String UNAVAILABLE = "The Firestore service is currently unavailable.";
  static const String DEADLINE_EXCEEDED = "The operation took too long to complete. Please try again.";
  static const String ALREADY_EXISTS = "The document already exists.";
  static const String NOT_FOUND = "The document was not found.";
  static const String RESOURCE_EXHAUSTED = "The resource limit has been reached.";
  static const String FAILED_PRECONDITION = "Operation was rejected due to failed preconditions.";
  static const String ABORTED = "The operation was aborted due to a conflict.";
  static const String OUT_OF_RANGE = "Operation is out of valid range.";
  static const String INTERNAL = "Internal server error. Please try again later.";
  static const String UNIMPLEMENTED = "This operation is not implemented or supported.";
  static const String DATA_LOSS = "Data loss occurred. Please try again.";
  static const String CANCELLED = "The operation was cancelled.";
  static const String UNKNOWN = "An unknown error occurred.";
  static const String DEFAULT = "An unknown error occurred.";
}

extension DataSourceExtension on DataSource {
  FirebaseErrorModel getFailure() {
    switch (this) {
      case DataSource.INVALID_EMAIL:
        return FirebaseErrorModel(errorCode: ResponseCode.INVALID_EMAIL, message: ResponseMessage.INVALID_EMAIL);
      case DataSource.USER_NOT_FOUND:
        return FirebaseErrorModel(errorCode: ResponseCode.USER_NOT_FOUND, message: ResponseMessage.USER_NOT_FOUND);
      case DataSource.WRONG_PASSWORD:
        return FirebaseErrorModel(errorCode: ResponseCode.WRONG_PASSWORD, message: ResponseMessage.WRONG_PASSWORD);
      case DataSource.USER_DISABLED:
        return FirebaseErrorModel(errorCode: ResponseCode.USER_DISABLED, message: ResponseMessage.USER_DISABLED);
      case DataSource.OPERATION_NOT_ALLOWED:
        return FirebaseErrorModel(errorCode: ResponseCode.OPERATION_NOT_ALLOWED, message: ResponseMessage.OPERATION_NOT_ALLOWED);
      case DataSource.TOO_MANY_REQUESTS:
        return FirebaseErrorModel(errorCode: ResponseCode.TOO_MANY_REQUESTS, message: ResponseMessage.TOO_MANY_REQUESTS);
      case DataSource.WEAK_PASSWORD:
        return FirebaseErrorModel(errorCode: ResponseCode.WEAK_PASSWORD, message: ResponseMessage.WEAK_PASSWORD);
      case DataSource.EMAIL_ALREADY_IN_USE:
        return FirebaseErrorModel(errorCode: ResponseCode.EMAIL_ALREADY_IN_USE, message: ResponseMessage.EMAIL_ALREADY_IN_USE);
      case DataSource.PERMISSION_DENIED:
        return FirebaseErrorModel(errorCode: ResponseCode.PERMISSION_DENIED, message: ResponseMessage.PERMISSION_DENIED);
      case DataSource.UNAVAILABLE:
        return FirebaseErrorModel(errorCode: ResponseCode.UNAVAILABLE, message: ResponseMessage.UNAVAILABLE);
      case DataSource.DEADLINE_EXCEEDED:
        return FirebaseErrorModel(errorCode: ResponseCode.DEADLINE_EXCEEDED, message: ResponseMessage.DEADLINE_EXCEEDED);
      case DataSource.ALREADY_EXISTS:
        return FirebaseErrorModel(errorCode: ResponseCode.ALREADY_EXISTS, message: ResponseMessage.ALREADY_EXISTS);
      case DataSource.NOT_FOUND:
        return FirebaseErrorModel(errorCode: ResponseCode.NOT_FOUND, message: ResponseMessage.NOT_FOUND);
      case DataSource.RESOURCE_EXHAUSTED:
        return FirebaseErrorModel(errorCode: ResponseCode.RESOURCE_EXHAUSTED, message: ResponseMessage.RESOURCE_EXHAUSTED);
      case DataSource.FAILED_PRECONDITION:
        return FirebaseErrorModel(errorCode: ResponseCode.FAILED_PRECONDITION, message: ResponseMessage.FAILED_PRECONDITION);
      case DataSource.ABORTED:
        return FirebaseErrorModel(errorCode: ResponseCode.ABORTED, message: ResponseMessage.ABORTED);
      case DataSource.OUT_OF_RANGE:
        return FirebaseErrorModel(errorCode: ResponseCode.OUT_OF_RANGE, message: ResponseMessage.OUT_OF_RANGE);
      case DataSource.INTERNAL:
        return FirebaseErrorModel(errorCode: ResponseCode.INTERNAL, message: ResponseMessage.INTERNAL);
      case DataSource.UNIMPLEMENTED:
        return FirebaseErrorModel(errorCode: ResponseCode.UNIMPLEMENTED, message: ResponseMessage.UNIMPLEMENTED);
      case DataSource.DATA_LOSS:
        return FirebaseErrorModel(errorCode: ResponseCode.DATA_LOSS, message: ResponseMessage.DATA_LOSS);
      case DataSource.CANCELLED:
        return FirebaseErrorModel(errorCode: ResponseCode.CANCELLED, message: ResponseMessage.CANCELLED);
      case DataSource.UNKNOWN:
        return FirebaseErrorModel(errorCode: ResponseCode.UNKNOWN, message: ResponseMessage.UNKNOWN);
      default:
        return FirebaseErrorModel(errorCode: ResponseCode.DEFAULT, message: ResponseMessage.DEFAULT);
    }
  }
}

class ErrorHandler implements Exception {
  late FirebaseErrorModel firebaseErrorModel;

  ErrorHandler.handleFirebaseAuthError(FirebaseAuthException error) {
    firebaseErrorModel = _handleFirebaseAuthError(error);
  }

  ErrorHandler.handleFirestoreError(Exception error) {
    firebaseErrorModel = _handleFirestoreError(error);
  }
}

FirebaseErrorModel _handleFirebaseAuthError(FirebaseAuthException error) {
  switch (error.code) {
    case 'invalid-email':
      return DataSource.INVALID_EMAIL.getFailure();
    case 'user-not-found':
      return DataSource.USER_NOT_FOUND.getFailure();
    case 'wrong-password':
      return DataSource.WRONG_PASSWORD.getFailure();
    case 'user-disabled':
      return DataSource.USER_DISABLED.getFailure();
    case 'operation-not-allowed':
      return DataSource.OPERATION_NOT_ALLOWED.getFailure();
    case 'too-many-requests':
      return DataSource.TOO_MANY_REQUESTS.getFailure();
    case 'weak-password':
      return DataSource.WEAK_PASSWORD.getFailure();
    case 'email-already-in-use':
      return DataSource.EMAIL_ALREADY_IN_USE.getFailure();
    default:
      return DataSource.DEFAULT.getFailure();
  }
}

FirebaseErrorModel _handleFirestoreError(Exception error) {
  if (error is FirebaseException) {
    switch (error.code) {
      case 'permission-denied':
        return DataSource.PERMISSION_DENIED.getFailure();
      case 'unavailable':
        return DataSource.UNAVAILABLE.getFailure();
      case 'deadline-exceeded':
        return DataSource.DEADLINE_EXCEEDED.getFailure();
      case 'already-exists':
        return DataSource.ALREADY_EXISTS.getFailure();
      case 'not-found':
        return DataSource.NOT_FOUND.getFailure();
      case 'resource-exhausted':
        return DataSource.RESOURCE_EXHAUSTED.getFailure();
      case 'failed-precondition':
        return DataSource.FAILED_PRECONDITION.getFailure();
      case 'aborted':
        return DataSource.ABORTED.getFailure();
      case 'out-of-range':
        return DataSource.OUT_OF_RANGE.getFailure();
      case 'internal':
        return DataSource.INTERNAL.getFailure();
      case 'unimplemented':
        return DataSource.UNIMPLEMENTED.getFailure();
      case 'data-loss':
        return DataSource.DATA_LOSS.getFailure();
      default:
        return DataSource.DEFAULT.getFailure();
    }
  } else {
    return DataSource.DEFAULT.getFailure();
  }
}