import 'package:core/failure_handler/base_failure.dart';

class UnknownFailure implements BaseFailure {
  const UnknownFailure({required this.message});

  @override
  final String message;
}

class CachingFailure implements BaseFailure {
  const CachingFailure({required this.message});

  @override
  final String message;
}

class ServerFailure implements BaseFailure {
  const ServerFailure({required this.message});

  @override
  final String message;
}

class NoDataFailure implements BaseFailure {
  const NoDataFailure({required this.message});

  @override
  final String message;
}
