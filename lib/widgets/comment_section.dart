import 'package:flutter/material.dart';
import 'package:jwt_auth/data/comment_config.dart';
import 'package:jwt_auth/data/ticket_config.dart';
import 'package:jwt_auth/services/api_service.dart';
import 'package:jwt_auth/theme/colors.dart';
import 'package:jwt_auth/widgets/comment_card.dart';
import 'package:jwt_auth/widgets/text_field.dart';

class CommentSection extends StatefulWidget {
  final List<CommentData>? comments;

  final Ticket user;
  final int id;
  const CommentSection(
      {Key? key, required this.id, this.comments, required this.user})
      : super(key: key);

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          if (widget.comments == null || widget.comments!.isEmpty)
            const Center(
              child: Text(
                'لا يوجد تعليقات',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          else
            for (var comment in widget.comments!) CommentCard(comment: comment),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () async {
                  // Replace with your actual ApiService method
                  ApiService().updateReport(
                    comment: commentController.text,
                    id: widget.id,
                  );

                  setState(() {
                    widget.comments?.add(CommentData(
                      ticket: 0,
                      comment: commentController.text,
                      createdAt: 'الأن',
                      createdBy: 'انت',
                    ));
                  });
                  commentController.clear();
                },
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all<Size>(
                    const Size(50, 50),
                  ),
                  backgroundColor: MaterialStateProperty.all<Color>(
                    AppColors.primaryColor,
                  ),
                ),
                child: const Text(
                  'اضافة تعليق',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: textField('تعليق', 'اضف تعليق', commentController),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
