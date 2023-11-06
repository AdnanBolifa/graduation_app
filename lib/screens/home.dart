import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jwt_auth/data/ticket_config.dart';
import 'package:jwt_auth/screens/ticket_page.dart';
import 'package:jwt_auth/screens/login.dart';
import 'package:jwt_auth/services/api_service.dart';
import 'package:jwt_auth/services/auth_service.dart';
import 'package:jwt_auth/theme/colors.dart';
import '../widgets/ticket_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();
  List<Ticket> ticketList = [];
  List<Ticket> originalList = [];
  bool isRefreshing = false;
  bool noInternet = false;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchReports();
  }

  void _filterUsers(String query) {
    setState(() {
      if (query.isEmpty) {
        ticketList = List.from(originalList);
      } else {
        ticketList = originalList.where((ticket) {
          final queryLower = query.toLowerCase();
          return ticket.userName.toLowerCase().contains(queryLower) ||
              ticket.mobile.toLowerCase().contains(queryLower) ||
              ticket.acc!.toLowerCase().contains(queryLower);
        }).toList();
      }
    });
  }

  Future<void> _fetchReports() async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult != ConnectivityResult.none) {
      setState(() {
        isRefreshing = true;
        noInternet = false;
      });

      try {
        if (context.mounted) {
          final users = await ApiService().getReports(context);
          if (users != null) {
            setState(() {
              ticketList = users;
              originalList = ticketList;
            });
          } else {
            _handleError();
            throw Exception('ApiService returned null or an error response.');
          }
        }
      } catch (e) {
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

  void _retryFetchingData() {
    // Clear the error flag and attempt to fetch data again.
    setState(() {
      hasError = false;
    });
    _fetchReports();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("الرئيسية"),
        centerTitle: true,
        leading: PopupMenuButton(
          icon: const Icon(Icons.menu),
          onSelected: (value) {
            if (value == 'logout') {
              searchController.clear();
              AuthService().logout();
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const LoginPage()));
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'logout',
              child: Text('تسجيل الخروج'),
            ),
          ],
        ),
      ),
      body: noInternet || hasError
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    noInternet
                        ? "لا يوجد اتصال بالإنترنت"
                        : "An error occurred",
                    style: const TextStyle(fontSize: 18),
                  ),
                  ElevatedButton(
                    onPressed: _retryFetchingData,
                    child: const Text("حاول مرة أخرى"),
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
                      onChanged: _filterUsers,
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
                    child: ticketList.isEmpty
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : ListView.builder(
                            itemCount: ticketList.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: ticketList[index].status == 'inprogress'
                                    ? () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => AddTicket(
                                                ticket: ticketList[index]),
                                          ),
                                        );
                                      }
                                    : null,
                                child: TicketCard(
                                  ticket: ticketList[index],
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddTicket(),
            ),
          );
        },
        backgroundColor: AppColors.primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
