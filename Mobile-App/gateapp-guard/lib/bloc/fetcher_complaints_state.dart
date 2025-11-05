part of 'fetcher_complaints_cubit.dart';

/// COMPLAINTS STATES START
class ComplaintsLoading extends FetcherComplaintsLoading {
  const ComplaintsLoading();
}

class ComplaintsLoaded extends FetcherComplaintsLoaded {
  final RemoteResponseType<Complaint> complaints;
  ComplaintsLoaded(this.complaints) {
    complaints.isLoading = false;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ComplaintsLoaded && other.complaints == complaints;
  }

  @override
  int get hashCode => complaints.hashCode;
}

class ComplaintsFail extends FetcherComplaintsFail {
  ComplaintsFail(String message, String messageKey)
      : super(message, messageKey);
}

/// COMPLAINTS STATES END

/// BASE STATES START
abstract class FetcherComplaintsState {
  const FetcherComplaintsState();
}

class FetcherComplaintsInitial extends FetcherComplaintsState {
  const FetcherComplaintsInitial();
}

class FetcherComplaintsLoading extends FetcherComplaintsState {
  const FetcherComplaintsLoading();
}

class FetcherComplaintsLoaded extends FetcherComplaintsState {
  const FetcherComplaintsLoaded();
}

class FetcherComplaintsFail extends FetcherComplaintsState {
  final String message, messageKey;

  const FetcherComplaintsFail(this.message, this.messageKey);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FetcherComplaintsFail &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          messageKey == other.messageKey;

  @override
  int get hashCode => message.hashCode ^ messageKey.hashCode;
}
/// BASE STATES END