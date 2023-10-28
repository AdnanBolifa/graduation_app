import 'package:flutter/material.dart';
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
        ticketList = ticketList.where((ticket) {
          return ticket.userName.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  bool isRefreshing = false;
  Future<void> _fetchReports() async {
    setState(() {
      isRefreshing = true;
    });

    try {
      final users = await ApiService().getReports(context);
      setState(() {
        ticketList = users;
        originalList = ticketList;
      });
    } catch (e) {
      debugPrint('Error while refreshing data: $e');
    } finally {
      setState(() {
        isRefreshing = false;
      });
    }
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
      body: RefreshIndicator(
        onRefresh: _fetchReports,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: searchController,
                onChanged: _filterUsers,
                decoration: InputDecoration(
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
                        final isTicketEnabled =
                            ticketList[index].enable ?? false;
                        return GestureDetector(
                          onTap: isTicketEnabled
                              ? () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AddTicket(ticket: ticketList[index]),
                                    ),
                                  );
                                }
                              : null,
                          child: TicketCard(
                            ticket: ticketList[index],
                            isDisabled: !isTicketEnabled,
                          ),
                        );
                      },
                    ),
            )
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
