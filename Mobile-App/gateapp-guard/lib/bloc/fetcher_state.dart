part of 'fetcher_cubit.dart';

/// VISITORLOGS STATES START
class VisitorLogsLoading extends FetcherLoading {
  const VisitorLogsLoading();
}

class VisitorLogsLoaded extends FetcherLoaded {
  final BaseListResponse<VisitorLog> visitorLogs;
  final String? status;
  final String? type;
  final String? code;
  const VisitorLogsLoaded(
      {required this.visitorLogs, this.status, this.type, this.code});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VisitorLogsLoaded &&
        other.visitorLogs == visitorLogs &&
        other.status == status &&
        other.type == type &&
        other.code == code;
  }

  @override
  int get hashCode =>
      visitorLogs.hashCode ^ status.hashCode ^ type.hashCode ^ code.hashCode;
}

class VisitorLogsFail extends FetcherFail {
  final String? type;
  VisitorLogsFail(String message, String messageKey, this.type)
      : super(message, messageKey);
}

/// VISITORLOGS STATES END

/// RESIDENTFLAT STATES START
class ResidentFlatsLoading extends FetcherLoading {
  const ResidentFlatsLoading();
}

class ResidentFlatsLoaded extends FetcherLoaded {
  final List<ResidentFlat> flats;
  const ResidentFlatsLoaded(this.flats);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ResidentFlatsLoaded &&
        foundation.listEquals(other.flats, flats);
  }

  @override
  int get hashCode => flats.hashCode;
}

class ResidentFlatsFail extends FetcherFail {
  ResidentFlatsFail(String message, String messageKey)
      : super(message, messageKey);
}

/// RESIDENTFLAT STATES END

/// RESIDENTBUILDING STATES START
class ResidentBuildingsLoading extends FetcherLoading {
  const ResidentBuildingsLoading();
}

class ResidentBuildingsLoaded extends FetcherLoaded {
  final List<ResidentBuilding> buildings;
  const ResidentBuildingsLoaded(this.buildings);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ResidentBuildingsLoaded &&
        foundation.listEquals(other.buildings, buildings);
  }

  @override
  int get hashCode => buildings.hashCode;
}

class ResidentBuildingsFail extends FetcherFail {
  ResidentBuildingsFail(String message, String messageKey)
      : super(message, messageKey);
}

/// RESIDENTBUILDING STATES END

/// RESIDENTPROJECT STATES START
class ResidentProjectsLoading extends FetcherLoading {
  const ResidentProjectsLoading();
}

class ResidentProjectsLoaded extends FetcherLoaded {
  final List<ResidentProject> projects;
  const ResidentProjectsLoaded(this.projects);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ResidentProjectsLoaded &&
        foundation.listEquals(other.projects, projects);
  }

  @override
  int get hashCode => projects.hashCode;
}

class ResidentProjectsFail extends FetcherFail {
  ResidentProjectsFail(String message, String messageKey)
      : super(message, messageKey);
}

/// RESIDENTPROJECT STATES END

/// SUPPORT STATES START
class SupportLoading extends FetcherLoading {
  const SupportLoading();
}

class SupportLoaded extends FetcherLoaded {
  const SupportLoaded();
}

class SupportLoadFail extends FetcherFail {
  SupportLoadFail(String message, String messageKey)
      : super(message, messageKey);
}

/// SUPPORT STATES END

/// USERME STATES START
class UserMeLoading extends FetcherLoading {
  const UserMeLoading();
}

class UserMeUpdating extends FetcherLoading {
  const UserMeUpdating();
}

class UserMeLoaded extends FetcherLoaded {
  final UserData userMe;
  final GuardProfile? guardProfile;

  UserMeLoaded(this.userMe, this.guardProfile) {
    userMe.setup();
    guardProfile?.setup();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserMeLoaded &&
          runtimeType == other.runtimeType &&
          userMe == other.userMe &&
          guardProfile == other.guardProfile;

  @override
  int get hashCode => userMe.hashCode ^ guardProfile.hashCode;
}

class UserMeError extends FetcherFail {
  UserMeError(String message, String messageKey) : super(message, messageKey);
}

/// USERME STATES END

/// BASE STATES START
abstract class FetcherState {
  const FetcherState();
}

class FetcherInitial extends FetcherState {
  const FetcherInitial();
}

class FetcherLoading extends FetcherState {
  const FetcherLoading();
}

class FetcherLoaded extends FetcherState {
  const FetcherLoaded();
}

class FetcherFail extends FetcherState {
  final String message, messageKey;

  const FetcherFail(this.message, this.messageKey);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FetcherFail &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          messageKey == other.messageKey;

  @override
  int get hashCode => message.hashCode ^ messageKey.hashCode;
}
/// BASE STATES END