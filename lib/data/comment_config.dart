class CommentData {
  final int? ticket;
  final String? comment;
  final String? createdAt;
  final String? createdBy;

  CommentData({
    required this.ticket,
    this.comment,
    this.createdAt,
    this.createdBy,
  });

  factory CommentData.fromJson(Map<String, dynamic> json) {
    final createdByJson = json['created_by'];
    final String? createdBy =
        createdByJson != null ? createdByJson['name'] : null;

    return CommentData(
      ticket: json['ticket'] as int,
      comment: json['comment'],
      createdAt: json['created_at'],
      createdBy: createdBy,
    );
  }
}
