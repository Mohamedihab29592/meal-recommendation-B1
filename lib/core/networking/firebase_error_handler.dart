import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_error_model.dart';

class FirebaseErrorHandler {
  static FirebaseErrorModel handle(dynamic error) {
    if (error is FirebaseAuthException) {
      return _handleAuthError(error);
    } else if (error is FirebaseException) {
      if (error.plugin == 'firebase_storage') {
        return _handleFirestorageError(error);
      }
      return _handleFirestoreError(error);
    } else {
      return FirebaseErrorModel(
          message: "An unknown error occurred", errorCode: -1);
    }
  }

  static FirebaseErrorModel _handleAuthError(FirebaseAuthException error) {
    switch (error.code) {
      case 'invalid-email':
        return _createError(1001, "The email address is invalid.");
      case 'user-not-found':
        return _createError(1002, "No user found with this email.");
      case 'wrong-password':
        return _createError(1003, "The password is incorrect.");
      case 'user-disabled':
        return _createError(1004, "The user account has been disabled.");
      case 'operation-not-allowed':
        return _createError(1005, "This operation is not allowed.");
      case 'too-many-requests':
        return _createError(1006, "Too many requests. Try again later.");
      case 'weak-password':
        return _createError(1007, "The password is too weak.");
      case 'email-already-in-use':
        return _createError(1008, "This email is already in use.");
      default:
        return _createError(-1, "An unknown authentication error occurred.");
    }
  }

  static FirebaseErrorModel _handleFirestoreError(FirebaseException error) {
    switch (error.code) {
      case 'permission-denied':
        return _createError(
            2001, "You do not have permission to perform this operation.");
      case 'unavailable':
        return _createError(
            2002, "The Firestore service is currently unavailable.");
      case 'deadline-exceeded':
        return _createError(
            2003, "The operation took too long to complete. Please try again.");
      case 'already-exists':
        return _createError(2004, "The document already exists.");
      case 'not-found':
        return _createError(2005, "The document was not found.");
      case 'resource-exhausted':
        return _createError(2006, "The resource limit has been reached.");
      case 'failed-precondition':
        return _createError(
            2007, "Operation was rejected due to failed preconditions.");
      case 'aborted':
        return _createError(
            2008, "The operation was aborted due to a conflict.");
      case 'out-of-range':
        return _createError(2009, "Operation is out of valid range.");
      case 'internal':
        return _createError(
            2010, "Internal server error. Please try again later.");
      case 'unimplemented':
        return _createError(
            2011, "This operation is not implemented or supported.");
      case 'data-loss':
        return _createError(2012, "Data loss occurred. Please try again.");
      default:
        return _createError(-1, "An unknown Firestore error occurred.");
    }
  }

  static FirebaseErrorModel _handleFirestorageError(FirebaseException error) {
    switch (error.code) {
      case 'unauthorized':
        return _createError(
            403, "User does not have permission to upload to this reference.");
      case 'canceled':
        return _createError(499, "Upload was canceled.");
      case 'object-not-found':
        return _createError(404, "File not found at specified path.");
      default:
        return _createError(-1, "An unknown Firebase Storage error occurred.");
    }
  }

  static FirebaseErrorModel _createError(int code, String message) {
    return FirebaseErrorModel(
      errorCode: code,
      message: message,
    );
  }
}
