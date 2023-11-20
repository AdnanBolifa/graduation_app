import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jwt_auth/data/location_config.dart';
import 'package:jwt_auth/data/ticket_config.dart';
import 'package:jwt_auth/main.dart';
import 'package:jwt_auth/screens/home.dart';
import 'package:jwt_auth/services/api_service.dart';
import 'package:jwt_auth/services/debouncer.dart';
import 'package:jwt_auth/services/location_services.dart';
import 'package:jwt_auth/theme/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class TicketCard extends StatefulWidget {
  final Ticket ticket;

  const TicketCard({Key? key, required this.ticket}) : super(key: key);

  @override
  State<TicketCard> createState() => _TicketCardState();
}

class _TicketCardState extends State<TicketCard> {
  //final AsyncMemoizer _memoizer = AsyncMemoizer();
  final Debouncer _debouncer = Debouncer();
  bool isMissionStarted = false;

  @override
  Widget build(BuildContext context) {
    MaterialColor inProgress = Colors.yellow;
    MaterialColor idle = Colors.grey;
    MaterialColor closed = Colors.green;

    final LocationService locationService = LocationService();
    LocationData? locationData;
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Container(
                decoration: widget.ticket.status == 'done'
                    ? BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      )
                    : null,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.ticket.acc!} - ${widget.ticket.userName}',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      textDirection: TextDirection.ltr,
                    ),
                    Text(
                      widget.ticket.mobile,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                      textDirection: TextDirection.ltr,
                    ),
                    Text(
                      "[${widget.ticket.createdAt!}]",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                      textDirection: TextDirection.ltr,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'المكان:  ${widget.ticket.place!}',
                      style: const TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold),
                      textDirection: TextDirection.ltr,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      widget.ticket.lastComment!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                      textDirection: TextDirection.ltr,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(3),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              shape: BoxShape.rectangle,
                            ),
                            child: widget.ticket.status != 'done'
                                ? ElevatedButton(
                                    style: widget.ticket.status == 'notstarted'
                                        ? ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor)
                                        : ElevatedButton.styleFrom(
                                            backgroundColor: Colors.grey[300],
                                          ),
                                    onPressed: widget.ticket.status == 'notstarted'
                                        ? () {
                                            showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              builder: (BuildContext context) {
                                                return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                                                  return SingleChildScrollView(
                                                    child: Container(
                                                      padding: const EdgeInsets.all(16),
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          const Text(
                                                            'هل أنت متأكد من بدء المهمة؟',
                                                            style: TextStyle(fontSize: 18),
                                                          ),
                                                          const SizedBox(height: 16),
                                                          ElevatedButton(
                                                            onPressed: () {
                                                              _debouncer.run(() async {
                                                                try {
                                                                  setState(() {
                                                                    isMissionStarted = true;
                                                                  });

                                                                  locationData = await locationService.getUserLocation();
                                                                  ApiService().startTimer(locationData!, widget.ticket.id);

                                                                  setState(() {
                                                                    isMissionStarted = false;
                                                                  });

                                                                  if (context.mounted) {
                                                                    Navigator.of(context).pop();
                                                                    navigatorKey.currentState?.push(
                                                                      MaterialPageRoute(
                                                                        builder: (context) => const HomeScreen(),
                                                                      ),
                                                                    );
                                                                  }
                                                                } catch (error) {
                                                                  ApiService().handleErrorMessage(msg: "ERROR: $error");
                                                                }
                                                              });
                                                            },
                                                            child: isMissionStarted
                                                                ? const CircularProgressIndicator(
                                                                    color: Colors.white,
                                                                  )
                                                                : const Text('نعم'),
                                                          ),
                                                          const SizedBox(height: 16),
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(context).pop();
                                                            },
                                                            child: const Text('إلغاء'),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                });
                                              },
                                            );
                                          }
                                        : () {
                                            Fluttertoast.showToast(msg: 'هذه المهمة قد بدأت بالفعل');
                                          },
                                    child: Text(
                                      'بدأ المهمة الان',
                                      style: widget.ticket.status == 'notstarted' ? const TextStyle(fontWeight: FontWeight.bold) : TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[600]),
                                    ),
                                  )
                                : null,
                          ),
                        ),
                        //Call button
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: const EdgeInsets.all(3),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    color: Colors.grey[300],
                                  ),
                                  child: widget.ticket.status != 'done'
                                      ? IconButton(
                                          onPressed: () {
                                            _makePhoneCall(widget.ticket.mobile);
                                          },
                                          icon: const Icon(
                                            Icons.phone,
                                            size: 30,
                                            color: Colors.black,
                                          ),
                                        )
                                      : null,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 15,
              right: 12,
              child: Container(
                width: 15,
                height: 15,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.ticket.status == 'inprogress' ? inProgress : (widget.ticket.status == 'notstarted' ? idle : closed),
                ),
              ),
            ),
          ],
        ));
  }

  void _makePhoneCall(String phoneNumber) async {
    final Uri url = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
