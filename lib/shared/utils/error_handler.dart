import 'package:flutter/material.dart';
import '../core/failure.dart';

/// Global error handler for consistent error UI
class GlobalErrorHandler {
  /// Handle failure with appropriate UI response
  static void handle(Failure failure, BuildContext context, {
    VoidCallback? onRetry,
    VoidCallback? onDismiss,
  }) {
    if (failure is ValidationFailure) {
      _handleValidationFailure(failure, context);
    } else if (failure is UnauthorizedFailure) {
      _handleUnauthorizedFailure(failure, context);
    } else if (failure is NetworkFailure) {
      _handleNetworkFailure(failure, context, onRetry: onRetry);
    } else if (failure is NotFoundFailure) {
      _handleNotFoundFailure(failure, context);
    } else {
      _handleGenericFailure(failure, context, onRetry: onRetry);
    }
  }

  static void _handleValidationFailure(
    ValidationFailure failure,
    BuildContext context,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(failure.userMessage),
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void _handleUnauthorizedFailure(
    UnauthorizedFailure failure,
    BuildContext context,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Session Expired'),
        content: const Text('Your session has expired. Please login again.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Navigate to login
              // context.read<AuthBloc>().add(LogoutEvent());
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }

  static void _handleNetworkFailure(
    NetworkFailure failure,
    BuildContext context, {
    VoidCallback? onRetry,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.wifi_off, color: Colors.white),
            SizedBox(width: 12),
            Expanded(child: Text('No internet connection')),
          ],
        ),
        backgroundColor: Colors.red[700],
        duration: const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
        action: onRetry != null
            ? SnackBarAction(
                label: 'RETRY',
                textColor: Colors.white,
                onPressed: onRetry,
              )
            : null,
      ),
    );
  }

  static void _handleNotFoundFailure(
    NotFoundFailure failure,
    BuildContext context,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Not Found'),
        content: Text(failure.resource != null
            ? '${failure.resource} not found'
            : failure.message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  static void _handleGenericFailure(
    Failure failure,
    BuildContext context, {
    VoidCallback? onRetry,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(failure.userMessage),
        backgroundColor: Colors.red[700],
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        action: failure.isRetryable && onRetry != null
            ? SnackBarAction(
                label: 'RETRY',
                textColor: Colors.white,
                onPressed: onRetry,
              )
            : null,
      ),
    );
  }

  /// Show error dialog with details
  static void showErrorDialog(
    BuildContext context,
    Failure failure, {
    VoidCallback? onRetry,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red[700]),
            const SizedBox(width: 12),
            const Text('Error'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(failure.userMessage),
            if (failure.details != null) ...[
              const SizedBox(height: 12),
              const Text(
                'Details:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(failure.details.toString()),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('CLOSE'),
          ),
          if (failure.isRetryable && onRetry != null)
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onRetry();
              },
              child: const Text('RETRY'),
            ),
        ],
      ),
    );
  }
}
