import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'widgets/message_card.dart';
import '../home/widgets/search_bar_widget.dart';
import 'chat/chat_screen.dart';
import '../../services/chat_service.dart';
import '../../models/chat_model.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  String _searchQuery = '';
  Key _refreshKey = UniqueKey();

  void _refreshData() {
    setState(() => _refreshKey = UniqueKey());
  }

  @override
  Widget build(BuildContext context) {
    final chatService = Provider.of<ChatService>(context);
    final currentUserId = chatService.currentUserId;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            SizedBox(
              width: double.infinity,
              child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0x4DA2F301), width: 1),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Messages',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Thursday, February 5, 2026',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SearchBarWidget(
                    hint: 'Search chats and messages...',
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                ],
              ),
              ),
            ),
            // Message list
            Expanded(
              child: Builder(
                builder: (context) {
                  final dummyItems = [
                    _DummyMessageData(
                      name: 'Sarah Johnson',
                      message: "That sounds great! I'm available..",
                      time: '5 min ago',
                      image: 'assets/chat_image1.png',
                      unreadCount: 2,
                    ),
                    _DummyMessageData(
                      name: 'Mike Davis',
                      message: 'Thanks for considering my application!',
                      time: '1 hour ago',
                      image: 'assets/chat_image2.png',
                      unreadCount: 0,
                    ),
                    _DummyMessageData(
                      name: 'Emma Wilson',
                      message: 'Can we discuss the contract details?',
                      time: '2 hours ago',
                      image: 'assets/chat_image3.png',
                      unreadCount: 1,
                    ),
                    _DummyMessageData(
                      name: 'Alex Turner',
                      message: 'Perfect, see you at the venue!',
                      time: 'Yesterday',
                      image: 'assets/message_image1.jpg',
                      unreadCount: 0,
                    ),
                  ];

                  final filteredItems = dummyItems.where((item) {
                    if (_searchQuery.isEmpty) return true;
                    return item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                           item.message.toLowerCase().contains(_searchQuery.toLowerCase());
                  }).toList();

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1A1F),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(32),
                                  child: Image.asset(
                                    item.image,
                                    width: 64,
                                    height: 64,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                if (item.unreadCount > 0)
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFA2F301),
                                        shape: BoxShape.circle,
                                      ),
                                      constraints: const BoxConstraints(
                                        minWidth: 20,
                                        minHeight: 20,
                                      ),
                                      child: Text(
                                        '${item.unreadCount}',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        item.name,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        item.time,
                                        style: TextStyle(
                                          color: Colors.white.withValues(alpha: 0.5),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    item.message,
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.6),
                                      fontSize: 14,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DummyMessageData {
  final String name;
  final String message;
  final String time;
  final String image;
  final int unreadCount;

  const _DummyMessageData({
    required this.name,
    required this.message,
    required this.time,
    required this.image,
    required this.unreadCount,
  });
}
