import 'package:equatable/equatable.dart';

class Instructor extends Equatable {
  const Instructor({
    required this.id,
    required this.name,
    required this.headline,
    required this.bio,
    required this.avatarUrl,
  });

  final String id;
  final String name;
  final String headline;
  final String bio;
  final String avatarUrl;

  @override
  List<Object?> get props => [id, name, headline, bio, avatarUrl];
}
