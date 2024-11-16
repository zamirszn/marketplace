import 'package:marketplace/data/models/review_model.dart';

class ReviewModelEntity {
  final int? id;
  final DateTime? dateCreated;
  final String? description;
  final Owner? owner;
  final double? rating;

  ReviewModelEntity({
    this.id,
    this.dateCreated,
    this.description,
    this.owner,
    this.rating,
  });
}
