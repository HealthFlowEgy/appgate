part of 'app_cubit.dart';

abstract class AppState {}

class Uninitialized extends AppState {}

class Initialized extends AppState {
  final bool isDemoShowLangs;
  Initialized(this.isDemoShowLangs);
}

class Authenticated extends Initialized {
  final bool isProfileComplete;
  Authenticated(bool isDemoShowLangs, this.isProfileComplete)
      : super(isDemoShowLangs);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Authenticated &&
        other.isProfileComplete == isProfileComplete;
  }

  @override
  int get hashCode => isProfileComplete.hashCode;
}

class Unauthenticated extends Initialized {
  final bool isProfileIssue;
  Unauthenticated(bool isDemoShowLangs, this.isProfileIssue)
      : super(isDemoShowLangs);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Unauthenticated && other.isProfileIssue == isProfileIssue;
  }

  @override
  int get hashCode => isProfileIssue.hashCode;
}

class FailureState extends AppState {
  final String msgKey;
  FailureState(this.msgKey);
  @override
  String toString() => 'FailureState(msgKey: $msgKey)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FailureState && other.msgKey == msgKey;
  }

  @override
  int get hashCode => msgKey.hashCode;
}
