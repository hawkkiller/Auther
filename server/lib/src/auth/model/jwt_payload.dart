import 'package:meta/meta.dart';

@immutable
final class JwtPayload {
  JwtPayload({
    required this.userId,
    required this.iat,
    required this.exp,
  });

  final int userId;
  final int iat;
  final int exp;

  factory JwtPayload.fromJson(Map<String, dynamic> json) => JwtPayload(
        userId: json['userId'] as int,
        iat: json['iat'] as int,
        exp: json['exp'] as int,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'userId': userId,
        'iat': iat,
        'exp': exp,
      };
}
