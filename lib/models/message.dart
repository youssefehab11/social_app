class MessageModel {
  late String messageId;
  late String senderId;
  late String receiverId;
  late String messageText;
  late String messageTime;

  MessageModel({
    required this.messageId,
    required this.senderId,
    required this.receiverId,
    required this.messageText,
    required this.messageTime,
  });

  MessageModel.fromJson(Map<String, dynamic>? json) {
    messageId = json?['messageId'];
    senderId = json?['senderId'];
    receiverId = json?['receiverId'];
    messageText = json?['messageText'];
    messageTime = json?['messageTime'];

  }

  Map<String, dynamic> toMap() {
    return {
      'messageId': messageId,
      'senderId': senderId,
      'receiverId': receiverId,
      'messageText': messageText,
      'messageTime': messageTime,
    };
  }
}
