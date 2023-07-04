enum ErrorCode {
  unknown(1),
  invalidBody(2),
  userExists(3),
  userNotFound(4),
  refreshTokenExpired(5),
  tokenMalformed(6);

  const ErrorCode(this.code);

  final int code;
}
