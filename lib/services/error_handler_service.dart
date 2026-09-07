import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:receipt_management_flutter/core/exceptions/app_exception.dart';
import 'package:receipt_management_flutter/core/utils/snackbar_helper.dart';

/// Global error handler service
class ErrorHandlerService extends GetxService {
  /// Handle any exception with appropriate user feedback
  void handleError(dynamic error, {String? context}) {
    debugPrint('Error${context != null ? ' [$context]' : ''}: $error');

    if (error is NetworkException) {
      _handleNetworkError(error);
    } else if (error is StorageException) {
      _handleStorageError(error);
    } else if (error is AuthException) {
      _handleAuthError(error);
    } else if (error is ValidationException) {
      _handleValidationError(error);
    } else if (error is SyncException) {
      _handleSyncError(error);
    } else {
      SnackbarHelper.error(
        'Something went wrong. Please try again.',
        title: 'Error',
      );
    }
  }

  void _handleNetworkError(NetworkException error) {
    switch (error.code) {
      case 'NO_INTERNET':
        SnackbarHelper.offline();
        break;
      case 'TIMEOUT':
        SnackbarHelper.warning(error.message);
        break;
      default:
        SnackbarHelper.error(error.message);
    }
  }

  void _handleStorageError(StorageException error) {
    switch (error.code) {
      case 'CORRUPTION':
        SnackbarHelper.error(error.message, title: 'Storage Error');
        break;
      default:
        SnackbarHelper.error(error.message);
    }
  }

  void _handleAuthError(AuthException error) {
    SnackbarHelper.error(error.message, title: 'Authentication');
  }

  void _handleValidationError(ValidationException error) {
    SnackbarHelper.warning(error.message, title: 'Validation');
  }

  void _handleSyncError(SyncException error) {
    switch (error.code) {
      case 'CONFLICT':
        SnackbarHelper.warning(error.message, title: 'Sync Conflict');
        break;
      default:
        SnackbarHelper.error(error.message, title: 'Sync');
    }
  }

  /// Handle errors silently (logging only)
  void handleSilent(dynamic error, {String? context}) {
    debugPrint('Silent Error${context != null ? ' [$context]' : ''}: $error');
  }
}
