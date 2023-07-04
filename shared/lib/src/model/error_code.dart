enum ErrorCode {
  unknown(1),
  invalidBody(2),
  userExists(3),
  userNotFound(4),
  ;

  const ErrorCode(this.code);

  final int code;
}
