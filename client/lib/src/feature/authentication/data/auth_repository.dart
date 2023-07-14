import 'package:auther_client/src/feature/authentication/data/auth_data_provider.dart';
import 'package:auther_client/src/feature/authentication/model/user.dart';
import 'package:shared/model.dart';

abstract interface class AuthRepository {
  /// Returns a stream of [TokenPair]s.
  ///
  /// The stream will emit a new [TokenPair] whenever the user's
  /// authentication state changes.
  ///
  /// If the user is not authenticated, the stream will emit `null`.
  ///
  /// If the user is authenticated, the stream will emit a [TokenPair]
  ///
  /// When listener is added to the stream, the stream will emit the
  /// current [TokenPair] immediately.
  Stream<TokenPair?> get tokenPairStream;

  /// Returns a stream of [User]s.
  ///
  /// The stream will emit a new [User] whenever the user's
  /// authentication state changes.
  ///
  /// If the user is not authenticated, the stream will emit `null`.
  ///
  /// If the user is authenticated, the stream will emit a [User]
  ///
  /// When listener is added to the stream, the stream will emit the
  /// current [User] immediately.
  Stream<User?> get userStream;

  /// Returns the current [User].
  User? getUser();

  /// Returns the current [TokenPair].
  TokenPair? getTokenPair();

  /// Clear the current [TokenPair].
  Future<void> signOut();

  /// Attempts to sign in with the given [email] and [password].
  Future<User> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Attempts to sign up with the given [email] and [password].
  Future<User> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String username,
  });

  /// Attempts to sign in anonymously.
  Future<User> signInAnonymously();
}

final class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthDataProvider authDataProvider,
  }) : _authDataProvider = authDataProvider;

  final AuthDataProvider _authDataProvider;

  @override
  Stream<TokenPair?> get tokenPairStream => _authDataProvider.tokenPairStream;

  @override
  TokenPair? getTokenPair() => _authDataProvider.getTokenPair();

  @override
  Stream<User?> get userStream => _authDataProvider.userStream;

  @override
  User? getUser() => _authDataProvider.getUser();

  @override
  Future<void> signOut() => _authDataProvider.signOut();

  @override
  Future<User> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) =>
      _authDataProvider.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

  @override
  Future<User> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String username,
  }) =>
      _authDataProvider.signUpWithEmailAndPassword(
        email: email,
        password: password,
        username: username,
      );

  @override
  Future<User> signInAnonymously() => _authDataProvider.signInAnonymously();
}
