import 'package:equatable/equatable.dart';

class Video extends Equatable {
  final int id;
  final String userType;
  final String title;
  final String description;
  final String url;
  final String fileType;
  final String dateAdded;
  const Video({
    required this.id,
    required this.userType,
    required this.title,
    required this.description,
    required this.url,
    required this.fileType,
    required this.dateAdded,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [id];
}
