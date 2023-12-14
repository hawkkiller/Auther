import 'package:sizzle_starter/src/core/components/rest_client/rest_client.dart';
import 'package:sizzle_starter/src/feature/auth/data/auth_datasource.dart';

/// Auth repository
abstract interface class AuthRepository {
  /// Sign in with email and password.
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Sign up with email and password.
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Sign out the current user.
  Future<void> signOut();

  /// The stream of [AuthenticationStatus] of the current user.
  Stream<AuthenticationStatus> getAuthStateChanges();
}

/// Auth repository implementation
final class AuthRepositoryImpl implements AuthRepository {
  /// Create an [AuthRepositoryImpl] instance.
  AuthRepositoryImpl({
    required AuthStatusDataSource authStatusDataSource,
    required AuthDataSource authDataSource,
  })  : _authStatusDataSource = authStatusDataSource,
        _authDataSource = authDataSource;

  final AuthStatusDataSource _authStatusDataSource;
  final AuthDataSource _authDataSource;

  @override
  Stream<AuthenticationStatus> getAuthStateChanges() =>
      _authStatusDataSource.getAuthenticationStatusStream();

  @override
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) =>
      _authDataSource.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

  @override
  Future<void> signOut() => _authDataSource.signOut();

  @override
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) =>
      _authDataSource.signUpWithEmailAndPassword(
        email: email,
        password: password,
      );
}
