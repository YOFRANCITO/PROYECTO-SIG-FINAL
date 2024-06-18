class LoginResponse {
  final int statusCode;
  final String message;
  final String token;
  final String refreshToken;
  final String expirationTime;
  final String role;
  final String name;
  final int id;
  

  LoginResponse({
    required this.statusCode,
    required this.message,
    required this.token,
    required this.refreshToken,
    required this.expirationTime,
    required this.role,
    required this.name,

    required this.id,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      statusCode: json['statusCode'],
      message: json['message'],
      token: json['token'],
      refreshToken: json['refreshToken'],
      expirationTime: json['expirationTime'],
      role: json['role'],
      id: json['id'],
       name: json['name'],
    );
  }
}