part of 'fetcher_visitor_logs_cubit.dart';

/// VISITORLOGUPDATE STATES START
class VisitorLogUpdateLoading extends FetcherVisitorLogsLoading {
  final String type;
  final int visitorLogId;
  const VisitorLogUpdateLoading(this.type, this.visitorLogId);
}

class VisitorLogUpdateLoaded extends FetcherVisitorLogsLoaded {
  final VisitorLog visitorLog;
  VisitorLogUpdateLoaded(this.visitorLog);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VisitorLogUpdateLoaded && other.visitorLog == visitorLog;
  }

  @override
  int get hashCode => visitorLog.hashCode;
}

class VisitorLogUpdateFail extends FetcherVisitorLogsFail {
  final String type;
  VisitorLogUpdateFail(String message, String messageKey, this.type)
      : super(message, messageKey);
}

/// VISITORLOGUPDATE STATES END

/// VISITORLOGS STATES START
class VisitorLogsLoading extends FetcherVisitorLogsLoading {
  const VisitorLogsLoading();
}

class VisitorLogsLoaded extends FetcherVisitorLogsLoaded {
  final RemoteResponseType<VisitorLog> visitorLog;
  VisitorLogsLoaded(this.visitorLog);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VisitorLogsLoaded && other.visitorLog == visitorLog;
  }

  @override
  int get hashCode => visitorLog.hashCode;
}

class VisitorLogsFail extends FetcherVisitorLogsFail {
  final String? type;
  VisitorLogsFail(String message, String messageKey, this.type)
      : super(message, messageKey);
}

/// VISITORLOGS STATES END

/// BASE STATES START
abstract class FetcherVisitorLogsState {
  const FetcherVisitorLogsState();
}

class FetcherVisitorLogsInitial extends FetcherVisitorLogsState {
  const FetcherVisitorLogsInitial();
}

class FetcherVisitorLogsLoading extends FetcherVisitorLogsState {
  const FetcherVisitorLogsLoading();
}

class FetcherVisitorLogsLoaded extends FetcherVisitorLogsState {
  const FetcherVisitorLogsLoaded();
}

class FetcherVisitorLogsFail extends FetcherVisitorLogsState {
  final String message, messageKey;

  const FetcherVisitorLogsFail(this.message, this.messageKey);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FetcherVisitorLogsFail &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          messageKey == other.messageKey;

  @override
  int get hashCode => message.hashCode ^ messageKey.hashCode;
}
/// BASE STATES END