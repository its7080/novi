// user_model.dart
import 'package:hive/hive.dart';
import 'chat_message.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  final String email;

  @HiveField(1)
  final String password;

  @HiveField(2)
  final List<ChatMessage> chatHistory;

  UserModel({
    required this.email,
    required this.password,
    required this.chatHistory,
  });
}
