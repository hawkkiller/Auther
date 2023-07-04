import 'package:auther_server/src/auth/logic/auth_database.dart';
import 'package:auther_server/src/auth/logic/jwt_provider.dart';
import 'package:shared/model.dart';

abstract interface class AuthService {
  Future<TokenPair> signUp({
    required String username,
    required String password,
    required String email,
  });
}

final class AuthServiceImpl implements AuthService {
  AuthServiceImpl({
    required JWTProvider jwtProvider,
    required AuthDatabase authDatabase,
  })  : _authDatabase = authDatabase,
        _jwtProvider = jwtProvider;

  final AuthDatabase _authDatabase;
  final JWTProvider _jwtProvider;

  @override
  Future<TokenPair> signUp({
    required String username,
    required String password,
    required String email,
  }) async {
    if (password.length < 8 || password.length > 64) {
      throw ArgumentError('Password must be between 8 and 64 characters long');
    }

    final userId = await _authDatabase.signUp(
      username: username,
      password: password,
      email: email,
    );

    return _jwtProvider.createTokenPair(userId);
  }
}
