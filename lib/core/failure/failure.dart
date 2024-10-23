abstract class Failure {
  final String message;

  Failure({required this.message});
}

class ServerFailure extends Failure {
  ServerFailure() : super(message: "Server error occurred");
}

class NetworkFailure extends Failure {
  NetworkFailure() : super(message: "No Internet connection");
}

class CacheFailure extends Failure {
  CacheFailure() : super(message: "Cache error occurred");
}