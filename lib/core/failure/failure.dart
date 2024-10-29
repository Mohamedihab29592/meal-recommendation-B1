abstract class Failure {
  final String message;

  Failure({required this.message});
}

class ServerFailure extends Failure {
  ServerFailure({super.message = "Server failure"});
}

class NetworkFailure extends Failure {
  NetworkFailure() : super(message: "No Internet connection");
}

class AuthFailure extends Failure {
  AuthFailure({super.message = "Authentication failure"});
}