import 'package:equatable/equatable.dart';
import 'package:nandikrushi_farmer/domain/entity/video.dart';

class VideoModel extends Equatable {
  final int id;
  final String userType;
  final String title;
  final String description;
  final String url;
  final String fileType;
  final String dateAdded;
  const VideoModel({
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

  factory VideoModel.fromJson(Map<String, dynamic> json) => VideoModel(
        id: int.parse(json["id"]),
        userType: json["user_type"],
        title: json["title"],
        description: json["description"],
        url: json["url"],
        fileType: json["file_type"],
        dateAdded: json["date_added"],
      );

  Video toEntity() => Video(
      id: id,
      userType: userType,
      title: title,
      description: description,
      url: url,
      fileType: fileType,
      dateAdded: dateAdded);
}
