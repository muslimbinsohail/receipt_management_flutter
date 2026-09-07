/// Base app exception
class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;
  final StackTrace? stackTrace;

  const AppException({
    required this.message,
    this.code,
    this.originalError,
    this.stackTrace,
  });

  @override
  String toString() => 'AppException($code): $message';
}

/// Network-related exceptions
class NetworkException extends AppException {
  const NetworkException({
    required super.message,
    super.code = 'NETWORK_ERROR',
    super.originalError,
    super.stackTrace,
  });

  factory NetworkException.noInternet() => const NetworkException(
        message: 'No internet connection. Changes saved locally.',
        code: 'NO_INTERNET',
      );

  factory NetworkException.timeout() => const NetworkException(
        message: 'Connection timed out. Please try again.',
        code: 'TIMEOUT',
      );

  factory NetworkException.serverError([String? details]) => NetworkException(
        message: details ?? 'Server error occurred. Please try again later.',
        code: 'SERVER_ERROR',
      );
}

/// Storage-related exceptions
class StorageException extends AppException {
  const StorageException({
    required super.message,
    super.code = 'STORAGE_ERROR',
    super.originalError,
    super.stackTrace,
  });

  factory StorageException.readFailed([String? details]) => StorageException(
        message: details ?? 'Failed to read data from local storage.',
        code: 'READ_FAILED',
      );

  factory StorageException.writeFailed([String? details]) => StorageException(
        message: details ?? 'Failed to save data locally.',
        code: 'WRITE_FAILED',
      );

  factory StorageException.boxNotFound(String boxName) => StorageException(
        message: 'Storage box "$boxName" not found.',
        code: 'BOX_NOT_FOUND',
      );

  factory StorageException.corruption() => const StorageException(
        message: 'Local storage data appears corrupted. Attempting recovery.',
        code: 'CORRUPTION',
      );
}

/// Authentication exceptions
class AuthException extends AppException {
  const AuthException({
    required super.message,
    super.code = 'AUTH_ERROR',
    super.originalError,
    super.stackTrace,
  });

  factory AuthException.invalidCredentials() => const AuthException(
        message: 'Invalid email or password.',
        code: 'INVALID_CREDENTIALS',
      );

  factory AuthException.userNotFound() => const AuthException(
        message: 'No account found with this email.',
        code: 'USER_NOT_FOUND',
      );

  factory AuthException.emailAlreadyInUse() => const AuthException(
        message: 'An account already exists with this email.',
        code: 'EMAIL_ALREADY_IN_USE',
      );

  factory AuthException.weakPassword() => const AuthException(
        message: 'Password is too weak. Use at least 6 characters.',
        code: 'WEAK_PASSWORD',
      );

  factory AuthException.sessionExpired() => const AuthException(
        message: 'Your session has expired. Please sign in again.',
        code: 'SESSION_EXPIRED',
      );

  factory AuthException.unknown([String? details]) => AuthException(
        message: details ?? 'An authentication error occurred.',
        code: 'UNKNOWN_AUTH',
      );
}

/// Validation exceptions
class ValidationException extends AppException {
  final Map<String, String>? fieldErrors;

  const ValidationException({
    required super.message,
    this.fieldErrors,
    super.code = 'VALIDATION_ERROR',
    super.originalError,
    super.stackTrace,
  });
}

/// Sync exceptions
class SyncException extends AppException {
  const SyncException({
    required super.message,
    super.code = 'SYNC_ERROR',
    super.originalError,
    super.stackTrace,
  });

  factory SyncException.conflict(String documentId) => SyncException(
        message: 'Sync conflict detected for document $documentId.',
        code: 'CONFLICT',
      );

  factory SyncException.queueFull() => const SyncException(
        message: 'Sync queue is full. Some changes may be delayed.',
        code: 'QUEUE_FULL',
      );

  factory SyncException.maxRetriesExceeded(String documentId) => SyncException(
        message: 'Max sync retries exceeded for document $documentId.',
        code: 'MAX_RETRIES',
      );
}
