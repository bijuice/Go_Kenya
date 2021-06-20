import 'package:go_kenya/models/review.dart';

class CustomUser {
  final String? uid, firstName, lastName, email, avatar;
  final List<Review>? reviews;

  CustomUser(
      {this.uid,
      this.firstName,
      this.lastName,
      this.email,
      this.avatar,
      this.reviews});
}
