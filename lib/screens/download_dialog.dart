import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:open_file_plus/open_file_plus.dart';

class DownloadProgressDialog extends StatefulWidget {
  final String url;
  const DownloadProgressDialog({Key? key, required this.url}) : super(key: key);

  @override
  State<DownloadProgressDialog> createState() => _DownloadProgressDialogState();
}

class _DownloadProgressDialogState extends State<DownloadProgressDialog> {
  late double downloadProgress;
  late String downloadStatus;

  @override
  void initState() {
    super.initState();
    downloadProgress = 0.0;
    downloadStatus = 'جاري التحميل';
    downloadFile();
  }

  void downloadFile() {
    FileDownloader.downloadFile(
      url: widget.url,
      onProgress: (fileName, progress) {
        setState(() {
          downloadProgress = progress;
        });
      },
      onDownloadCompleted: (String path) {
        setState(() {
          downloadStatus = 'انتهى التحميل';
        });
        _openFile(path);
        Navigator.of(context)
            .pop(); // Close the dialog after download completion
      },
      onDownloadError: (error) {
        setState(() {
          downloadStatus = 'فشل التحميل';
        });
        debugPrint('DOWNLOAD ERROR: $error');
        Navigator.of(context).pop(); // Close the dialog on error
      },
    );
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
