import 'package:equatable/equatable.dart';
import 'package:flutter_app_chat/constant/message.dart';

class Chat extends Equatable {
  final int id;
  final int userId;
  final otherUserId;
  final List<Message> messages;
  Chat(
      {required this.id,
      required this.userId,
      required this.otherUserId,
      required this.messages});

  @override
  List<Object?> get props => [id, userId, otherUserId, messages];
}
