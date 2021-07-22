import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User(this.id, [this.username]);

  final String id;
  final String? username;

  @override
  List<Object> get props => [id];

  static const empty = User('-');
}
