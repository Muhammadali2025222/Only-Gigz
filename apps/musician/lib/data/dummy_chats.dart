import '../models/chat_model.dart';

final List<ChatModel> dummyChats = [
  ChatModel(
    id: 'chat_1',
    participantIds: ['current_user', 'org_1'],
    participantNames: {'current_user': 'Jordan Davis', 'org_1': 'Emily & John'},
    participantImages: {'current_user': 'assets/profile_image.png', 'org_1': 'assets/chat_image1.png'},
    lastMessage: 'Looking forward to having you perform at our wedding reception!',
    lastMessageTime: DateTime.now().subtract(const Duration(minutes: 15)),
    lastMessageSenderId: 'org_1',
    unreadCount: {'current_user': 1},
  ),
  ChatModel(
    id: 'chat_2',
    participantIds: ['current_user', 'org_2'],
    participantNames: {'current_user': 'Jordan Davis', 'org_2': 'Blue Moon Events'},
    participantImages: {'current_user': 'assets/profile_image.png', 'org_2': 'assets/chat_image2.png'},
    lastMessage: 'The contract has been signed and your deposit is scheduled.',
    lastMessageTime: DateTime.now().subtract(const Duration(hours: 2)),
    lastMessageSenderId: 'org_2',
    unreadCount: {'current_user': 0},
  ),
  ChatModel(
    id: 'chat_3',
    participantIds: ['current_user', 'org_3'],
    participantNames: {'current_user': 'Jordan Davis', 'org_3': 'SoundWave Productions'},
    participantImages: {'current_user': 'assets/profile_image.png', 'org_3': 'assets/chat_image1.png'},
    lastMessage: 'Could you arrive 30 minutes earlier for sound check?',
    lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
    lastMessageSenderId: 'org_3',
    unreadCount: {'current_user': 0},
  ),
];
