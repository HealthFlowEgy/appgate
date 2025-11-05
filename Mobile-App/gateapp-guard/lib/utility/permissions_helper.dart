import 'package:permission_handler/permission_handler.dart';

class PermissionsHelper {
  static bool askedOncePermissionCamAndMic = false;
  static bool askedOncePermissionStorage = false;
  static bool askedOncePermissionContacts = false;
  static bool askedOncePermissionMicAndStorage = false;

  static Future<bool> permissionIsGrantedCameraAndMicrophone() async {
    PermissionStatus permissionStatusCamera = await Permission.camera.status;
    PermissionStatus permissionStatusMicrophone =
        await Permission.microphone.status;
    return permissionStatusCamera == PermissionStatus.granted &&
        permissionStatusMicrophone == PermissionStatus.granted;
  }

  static Future<void> permissionGrantCameraAndMicrophone() async {
    await Permission.camera.request();
    await Permission.microphone.request();
  }

  static Future<bool> permissionIsGrantedMicrophoneAndStorage() async {
    PermissionStatus permissionStatusStorage =
        await Permission.manageExternalStorage.status;
    PermissionStatus permissionStatusMicrophone =
        await Permission.microphone.status;
    return permissionStatusStorage == PermissionStatus.granted &&
        permissionStatusMicrophone == PermissionStatus.granted;
  }

  static Future<void> permissionGrantMicrophoneAndStorage() async {
    await Permission.manageExternalStorage.request();
    await Permission.microphone.request();
  }

  static Future<bool> permissionIsGrantedStorage() async {
    PermissionStatus permissionStatusStorage =
        await Permission.manageExternalStorage.status;
    return permissionStatusStorage == PermissionStatus.granted;
  }

  static Future<void> permissionGrantStorage() =>
      Permission.manageExternalStorage.request();

  static Future<bool> permissionIsGrantedContacts() async {
    PermissionStatus permissionStatusContacts =
        await Permission.contacts.status;
    return permissionStatusContacts == PermissionStatus.granted;
  }

  static Future<void> permissionGrantContacts() =>
      Permission.contacts.request();
}
