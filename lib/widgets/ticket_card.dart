import 'package:flutter/material.dart';
import 'package:jwt_auth/data/ticket_config.dart';
import 'package:url_launcher/url_launcher.dart';

class TicketCard extends StatelessWidget {
  final Ticket ticket;
  final bool isDisabled;

  const TicketCard({Key? key, required this.ticket, required this.isDisabled})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          decoration: isDisabled
              ? BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                )
              : BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${ticket.acc!} - ${ticket.userName}',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                textDirection: TextDirection.ltr,
              ),
              Text(
                ticket.mobile,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
                textDirection: TextDirection.ltr,
              ),
              Text(
                "[${ticket.createdAt!}]",
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                ),
                textDirection: TextDirection.ltr,
              ),
              const SizedBox(height: 5),
              Text(
                ticket.place!,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                ),
                textDirection: TextDirection.ltr,
              ),
              const SizedBox(height: 5),
              Text(
                ticket.lastComment!,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
                textDirection: TextDirection.ltr,
              ),
              Align(
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
                      child: IconButton(
                        onPressed: () {
                          _makePhoneCall(ticket.mobile);
                        },
                        icon: const Icon(
                          Icons.phone,
                          size: 30,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
