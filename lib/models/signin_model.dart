class SignInModel {
  final String message;
  final String email;
  final int otp;

  SignInModel({
    required this.message,
    required this.email,
    required this.otp,
  });

  // Factory constructor to create an instance from a JSON map
  factory SignInModel.fromJson(Map<String, dynamic> json) {
    return SignInModel(
      message: json['message'],
      email: json['email'],
      otp: json['otp'],
    );
  }

  // Method to convert the instance back to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'email': email,
      'otp': otp,
    };
  }
}
