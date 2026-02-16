import 'package:flutter/material.dart';
import 'package:skillchain/Pages/chat/chat_page.dart';
import 'package:intl/intl.dart';

class ChatConversation {
  final String id;
  final String userId;
  final String userName;
  final String userAvatar;
  final String lastMessage;
  final DateTime lastMessageTime;
  final bool isOnline;
  final int unreadCount;
  final bool isMeLastSender;

  ChatConversation({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.lastMessage,
    required this.lastMessageTime,
    this.isOnline = false,
    this.unreadCount = 0,
    this.isMeLastSender = false,
  });
}

class ChatInboxScreen extends StatefulWidget {
  const ChatInboxScreen({super.key});

  @override
  State<ChatInboxScreen> createState() => _ChatInboxScreenState();
}

class _ChatInboxScreenState extends State<ChatInboxScreen> {
  // Sample conversations - in a real app, this would come from a service
  final List<ChatConversation> _conversations = [
    ChatConversation(
      id: '1',
      userId: 'user1',
      userName: 'Sarah Jenkins',
      userAvatar: 'https://i.pravatar.cc/150?img=47',
      lastMessage: 'Yes, Saturday afternoon works perfectly for me!',
      lastMessageTime: DateTime.now().subtract(const Duration(minutes: 15)),
      isOnline: true,
      unreadCount: 0,
      isMeLastSender: false,
    ),
    ChatConversation(
      id: '2',
      userId: 'user2',
      userName: 'David Chen',
      userAvatar: 'https://i.pravatar.cc/150?img=12',
      lastMessage: 'I can help you with React. When are you available?',
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 2)),
      isOnline: false,
      unreadCount: 2,
      isMeLastSender: false,
    ),
    ChatConversation(
      id: '3',
      userId: 'user3',
      userName: 'Elena Rodriguez',
      userAvatar: 'https://i.pravatar.cc/150?img=33',
      lastMessage: 'Thanks for the session! It was really helpful.',
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 5)),
      isOnline: true,
      unreadCount: 0,
      isMeLastSender: true,
    ),
    ChatConversation(
      id: '4',
      userId: 'user4',
      userName: 'Michael Thompson',
      userAvatar: 'https://i.pravatar.cc/150?img=20',
      lastMessage: 'Looking forward to our skill exchange session!',
      lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
      isOnline: false,
      unreadCount: 1,
      isMeLastSender: false,
    ),
    ChatConversation(
      id: '5',
      userId: 'user5',
      userName: 'Alex Johnson',
      userAvatar: 'https://i.pravatar.cc/150?img=51',
      lastMessage: 'Can we schedule for next week?',
      lastMessageTime: DateTime.now().subtract(const Duration(days: 2)),
      isOnline: false,
      unreadCount: 0,
      isMeLastSender: true,
    ),
  ];

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(time.year, time.month, time.day);

    if (messageDate == today) {
      return DateFormat('HH:mm').format(time);
    } else if (messageDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    } else if (now.difference(messageDate).inDays < 7) {
      return DateFormat('EEE').format(time); // Day of week
    } else {
      return DateFormat('MMM d').format(time);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Messages",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {
              // Implement search
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {
              // Show more options
            },
          ),
        ],
      ),
      body: _conversations.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "No conversations yet",
                    style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Start a conversation with someone!",
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _conversations.length,
              itemBuilder: (context, index) {
                final conversation = _conversations[index];
                return _ConversationTile(
                  conversation: conversation,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          chatUserId: conversation.userId,
                          chatUserName: conversation.userName,
                          chatUserAvatar: conversation.userAvatar,
                          isOnline: conversation.isOnline,
                        ),
                      ),
                    );
                  },
                  formatTime: _formatTime,
                );
              },
            ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  final ChatConversation conversation;
  final VoidCallback onTap;
  final String Function(DateTime) formatTime;

  const _ConversationTile({
    required this.conversation,
    required this.onTap,
    required this.formatTime,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade200, width: 0.5),
          ),
        ),
        child: Row(
          children: [
            // Avatar with online status
            Stack(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage: NetworkImage(conversation.userAvatar),
                  child: conversation.userAvatar.isEmpty
                      ? const Icon(Icons.person, color: Colors.black)
                      : null,
                ),
                if (conversation.isOnline)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            // Message content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          conversation.userName,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: conversation.unreadCount > 0
                                ? FontWeight.bold
                                : FontWeight.w500,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        formatTime(conversation.lastMessageTime),
                        style: TextStyle(
                          fontSize: 12,
                          color: conversation.unreadCount > 0
                              ? Colors.blue
                              : Colors.grey.shade600,
                          fontWeight: conversation.unreadCount > 0
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          conversation.lastMessage,
                          style: TextStyle(
                            fontSize: 14,
                            color: conversation.unreadCount > 0
                                ? Colors.black87
                                : Colors.grey.shade600,
                            fontWeight: conversation.unreadCount > 0
                                ? FontWeight.w500
                                : FontWeight.normal,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (conversation.unreadCount > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            conversation.unreadCount > 99
                                ? '99+'
                                : conversation.unreadCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

