import 'package:permission_handler/permission_handler.dart';

class PermissionManager {
  // Check and request necessary permissions
  Future<bool> checkAndRequestPermissions() async {
    bool isStorageGranted = await _checkAndRequestPermission(Permission.storage);
    bool isAccessMediaLocationGranted = await _checkAndRequestPermission(Permission.accessMediaLocation);
    bool isManageExternalStorageGranted = await _checkAndRequestPermission(Permission.manageExternalStorage);
    bool isLocationGranted = await _checkAndRequestPermission(Permission.location);

    // Return true only if all required permissions are granted
    return isStorageGranted && isAccessMediaLocationGranted && isManageExternalStorageGranted && isLocationGranted;
  }

  // Check and request a single permission
  Future<bool> _checkAndRequestPermission(Permission permission) async {
    var permissionStatus = await permission.status;

    if (!permissionStatus.isGranted) {
      // Request permission if not already granted
      await permission.request();

      // Check the permission status again after the request
      permissionStatus = await permission.status;

      // Return true if permission is granted, otherwise false
      return permissionStatus.isGranted;
    } else {
      // Permission is already granted
      return true;
    }
  }

  // Request all missing permissions
  Future<void> requestMissingPermissions() async {
    await _checkAndRequestPermission(Permission.storage);
    await _checkAndRequestPermission(Permission.accessMediaLocation);
    await _checkAndRequestPermission(Permission.manageExternalStorage);
    await _checkAndRequestPermission(Permission.location);
  }
}
