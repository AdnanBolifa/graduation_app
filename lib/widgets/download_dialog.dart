import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jwt_auth/widgets/error_dialog.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';

class DownloadProgressDialog extends StatefulWidget {
  final String url;
  const DownloadProgressDialog({Key? key, required this.url}) : super(key: key);

  @override
  State<DownloadProgressDialog> createState() => _DownloadProgressDialogState();
}

class _DownloadProgressDialogState extends State<DownloadProgressDialog> {
  late int downloadProgress;
  late String downloadStatus;

  @override
  void initState() {
    super.initState();
    downloadProgress = 0;
    downloadStatus = 'جاري التحميل';
    downloadFile();
  }

  Future<void> downloadFile() async {
    Dio dio = Dio();

    try {
      Directory? appDocDir = await getApplicationDocumentsDirectory();
      String downloadDir = '${appDocDir.path}/Download';

      // Ensure that the download directory exists
      await Directory(downloadDir).create(recursive: true);

      String fileName = 'Ticket.apk'; // You can change the filename as needed
      String savePath = '$downloadDir/$fileName';

      await dio.download(
        widget.url,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() {
              downloadProgress = (received / total * 100).floor();
            });
          }
        },
      );
      setState(() {
        downloadStatus = 'انتهى التحميل';
      });

      _openFile(savePath);
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    } catch (error) {
      setState(() {
        downloadStatus = 'فشل التحميل';
      });
      ErrorDialog(
        line1: "catch dio fun",
        line2: "DOWNLOAD ERROR: $error",
      );
      debugPrint('DOWNLOAD ERROR: $error');
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "تحديث متوفر",
        textDirection: TextDirection.rtl,
      ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "${(downloadProgress).toInt()}%",
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(width: 10),
          Text(
            downloadStatus,
          ),
        ],
      ),
    );
  }

  void _openFile(String path) {
    OpenFile.open(path);
  }
}
