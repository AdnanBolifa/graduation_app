import 'package:permission_handler/permission_handler.dart';

class CheckPermission {
  isStoragePermission() async {
    var isStorage = await Permission.storage.status;
    var isAccessLc = await Permission.accessMediaLocation.status;
    var isMnagExt = await Permission.manageExternalStorage.status;
    var isLoc = await Permission.location.status;
    if (!isStorage.isGranted ||
        !isAccessLc.isGranted ||
        !isMnagExt.isGranted ||
        !isLoc.isGranted) {
      await Permission.storage.request();
      await Permission.accessMediaLocation.request();
      await Permission.manageExternalStorage.request();
      await Permission.location.request();
      if (!isStorage.isGranted ||
          !isAccessLc.isGranted ||
          !isMnagExt.isGranted ||
          !isLoc.isGranted) {
        return false;
      } else {
        return true;
      }
    } else {
      return true;
    }
  }
}
