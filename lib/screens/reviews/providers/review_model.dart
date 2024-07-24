class ReviewComment {
  final String user;
  final String text;
  final String name;
  final String avatar;
  final DateTime date;

  ReviewComment({
    required this.user,
    required this.text,
    required this.name,
    required this.avatar,
    required this.date,
  });

  factory ReviewComment.fromJson(Map<String, dynamic> json) {
    return ReviewComment(
      user: json['user'],
      text: json['text'],
      name: json['name'] ?? '',
      avatar: json['avatar'] ?? '',
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user,
      'text': text,
      'name': name,
      'avatar': avatar,
      'date': date.toIso8601String(),
    };
  }
}

class Review {
  final String id;
  final String user;
  final String reviewText;
  final String reviewerName;
  final String reviewerEmail;
  final String reviewerAvatar;
  final DateTime reviewDate;
  final List<String> likes;
  final List<ReviewComment> reviewComments;

  Review({
    required this.id,
    required this.user,
    required this.reviewText,
    required this.reviewerName,
    required this.reviewerEmail,
    required this.reviewerAvatar,
    required this.reviewDate,
    required this.likes,
    required this.reviewComments,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    var likesFromJson = json['likes'] as List;
    List<String> likesList = likesFromJson.map((i) => i['user'] as String).toList();

    var commentsFromJson = json['reviewComments'] as List;
    List<ReviewComment> commentsList = commentsFromJson.map((i) => ReviewComment.fromJson(i)).toList();

    return Review(
      id: json['_id'],
      user: json['user'],
      reviewText: json['reviewText'],
      reviewerName: json['reviewerName'] ?? '',
      reviewerEmail: json['reviewerEmail'] ?? '',
      reviewerAvatar: json['reviewerAvatar'] ?? '',
      reviewDate: DateTime.parse(json['reviewDate']),
      likes: likesList,
      reviewComments: commentsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': user,
      'reviewText': reviewText,
      'reviewerName': reviewerName,
      'reviewerEmail': reviewerEmail,
      'reviewerAvatar': reviewerAvatar,
      'reviewDate': reviewDate.toIso8601String(),
      'likes': likes.map((i) => {'user': i}).toList(),
      'reviewComments': reviewComments.map((i) => i.toJson()).toList(),
    };
  }
}

