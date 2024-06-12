import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jwt_auth/data/history_config.dart';
import 'package:jwt_auth/services/api_service.dart';
import 'package:jwt_auth/services/check_permissions.dart';
import 'package:jwt_auth/widgets/history_card.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryPage> {
  final TextEditingController searchController = TextEditingController();
  List<History> historyList = [];
  List<History> originalList = [];
  bool isRefreshing = false;
  bool noInternet = false;
  bool hasError = false;
  bool noTickets = false;

  @override
  void initState() {
    super.initState();
    _fetchReports();
    _checkPermission();
  }

  bool isPermission = false;
  var permissionManager = PermissionManager();
  _checkPermission() async {
    bool arePermissionsGranted =
        await permissionManager.checkAndRequestPermissions();
    if (arePermissionsGranted) {
      setState(() {
        isPermission = true;
      });
    }
  }

  // void _filterUsers(String query) {
  //   setState(() {
  //     if (query.isEmpty) {
  //       historyList = List.from(originalList);
  //     } else {
  //       historyList = originalList.where((ticket) {
  //         final queryLower = query.toLowerCase();
  //         return ticket.userName.toLowerCase().contains(queryLower) ||
  //             ticket.mobile.toLowerCase().contains(queryLower) ||
  //             ticket.acc!.toLowerCase().contains(queryLower) ||
  //             ticket.place!.toLowerCase().contains(queryLower);
  //       }).toList();
  //     }
  //   });
  // }

  Future<void> _fetchReports() async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult != ConnectivityResult.none) {
      setState(() {
        isRefreshing = true;
        noInternet = false;
      });

      try {
        final users = await ApiService().getHistory();
        if (users != null && users.isNotEmpty) {
          setState(() {
            historyList = users;
            originalList = historyList;
          });
        } else if (users!.isEmpty) {
          _noTickets();
        } else {
          _handleError();
          throw Exception('ApiService returned null or an error response.');
        }
      } catch (e) {
        ApiService().handleErrorMessage(msg: "Error while refreshing data: $e");
        debugPrint('Error while refreshing data: $e');
        // Set a flag to indicate an error occurred.
        _handleError();
      } finally {
        setState(() {
          isRefreshing = false;
        });
      }
    } else {
      setState(() {
        noInternet = true;
      });
      Fluttertoast.showToast(msg: 'لايوجد انترنت');
      // Set a flag to indicate an error occurred.
      _handleError();
    }
  }

  void _handleError() {
    setState(() {
      hasError = true;
    });
  }

  void _noTickets() {
    setState(() {
      noTickets = true;
    });
  }

  void _retryFetchingData() {
    // Clear the error flag and attempt to fetch data again.
    setState(() {
      hasError = false;
      noTickets = false;
    });
    _fetchReports();
  }

  Future<bool> showUpdateConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text(
                "يوجد تحديث متوفر!",
                textDirection: TextDirection.rtl,
              ),
              content: const Text("هل تريد تحديث التطبيق؟",
                  textDirection: TextDirection.rtl),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text("نعم"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text("لا"),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("سجل الحالات"),
        centerTitle: true,
      ),
      body: noInternet || hasError || noTickets
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    noTickets
                        ? "😎 لا يوجد لديك اي بلاغ "
                        : noInternet
                            ? "لا يوجد اتصال بالإنترنت"
                            : "حدث خطأ يرجى تسجيل الخروج",
                    style: const TextStyle(fontSize: 22),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _retryFetchingData,
                    child: const Text(
                      "إعادة المحاولة",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _fetchReports,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: searchController,
                      // onChanged: _filterUsers,
                      decoration: InputDecoration(
                        hintTextDirection: TextDirection.rtl,
                        hintText: 'البحث عن كل شيء',
                        labelText: 'بحث',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: const Icon(Icons.search),
                      ),
                    ),
                  ),
                  Expanded(
                    child: historyList.isEmpty
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : ListView.builder(
                            itemCount: historyList.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                child: HistoryCard(
                                  ticket: historyList[index],
                                  onUpdate: _fetchReports,
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}
