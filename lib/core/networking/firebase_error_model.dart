class FirebaseErrorModel {
  final String? message;
  final int? errorCode;

  FirebaseErrorModel({
    required this.message,
    required this.errorCode,
  });

  factory FirebaseErrorModel.fromJson(Map<String, dynamic> json) {
    return FirebaseErrorModel(
      message: json['message'] as String?,
      errorCode: json['errorCode'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'errorCode': errorCode,
    };
  }
}