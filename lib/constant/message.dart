import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final int id;
  final int senderId;
  final int receiverId;
  final String message;
  final DateTime dateTime;
  final String timeString;
  Message(
      {required this.id,
      required this.senderId,
      required this.receiverId,
      required this.message,
      required this.dateTime,
      required this.timeString});

  @override
  List<Object?> get props => [id, receiverId, message, dateTime, timeString];
}
