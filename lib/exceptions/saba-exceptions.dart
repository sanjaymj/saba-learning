class WordAlreadyExistsException implements Exception {
  String cause;
  WordAlreadyExistsException(this.cause);
}
