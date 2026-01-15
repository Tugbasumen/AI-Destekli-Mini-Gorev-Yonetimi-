/// Base exception class for application errors
abstract class AppException implements Exception {
  final String message;
  final dynamic originalError;

  const AppException(this.message, [this.originalError]);

  @override
  String toString() => message;
}

/// Exception thrown when API request fails
class ApiException extends AppException {
  const ApiException(super.message, [super.originalError]);
}

/// Exception thrown when network connection fails
class NetworkException extends AppException {
  const NetworkException(super.message, [super.originalError]);
}

/// Exception thrown when task validation fails
class ValidationException extends AppException {
  const ValidationException(super.message);
}

/// Exception thrown when task is not found
class TaskNotFoundException extends AppException {
  const TaskNotFoundException([String? taskId])
    : super(taskId != null ? 'Task not found: $taskId' : 'Task not found');
}

/// Exception thrown when authentication fails
class AuthException extends AppException {
  const AuthException(super.message, [super.originalError]);
}
