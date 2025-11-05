import 'package:flutter/foundation.dart';

class RemoteResponseType<T> {
  String type;
  late bool isLoading;
  late bool allDone;
  late int page;
  late List<T> data;

  RemoteResponseType(this.type) {
    isLoading = false;
    allDone = false;
    page = 1;
    data = [];
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RemoteResponseType &&
        other.type == type &&
        listEquals(other.data, data);
  }

  @override
  int get hashCode {
    return type.hashCode ^ data.hashCode;
  }

  void reset() {
    isLoading = false;
    allDone = false;
    page = 1;
  }
}
