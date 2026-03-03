import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum MessageStatus { sending, sent, delivered, read }

class ChatMessage {
  final String text;
  final bool isMe;
  final DateTime timestamp;
  final MessageStatus status;
  final String? messageId;

  ChatMessage({
    required this.text,
    required this.isMe,
    required this.timestamp,
    this.status = MessageStatus.sent,
    this.messageId,
  });
}

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final String? senderName;
  final String? senderAvatar;
  final bool showAvatar;
  final bool isGrouped;

  const ChatBubble({
    super.key,
    required this.message,
    this.senderName,
    this.senderAvatar,
    this.showAvatar = true,
    this.isGrouped = false,
  });

  String _formatTime(DateTime time) {
    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final messageDate = DateTime(time.year, time.month, time.day);

      if (messageDate == today) {
        return DateFormat('HH:mm').format(time);
      } else if (messageDate == today.subtract(const Duration(days: 1))) {
        return 'Yesterday ${DateFormat('HH:mm').format(time)}';
      } else {
        return DateFormat('MMM d, HH:mm').format(time);
      }
    } catch (e) {
      // Fallback if date formatting fails
      return DateFormat('HH:mm').format(time);
    }
  }

  IconData _getStatusIcon(MessageStatus status) {
    switch (status) {
      case MessageStatus.sending:
        return Icons.access_time;
      case MessageStatus.sent:
        return Icons.check;
      case MessageStatus.delivered:
        return Icons.done_all;
      case MessageStatus.read:
        return Icons.done_all;
    }
  }

  Color _getStatusColor(MessageStatus status) {
    switch (status) {
      case MessageStatus.sending:
        return Colors.grey.shade400;
      case MessageStatus.sent:
        return Colors.grey.shade400;
      case MessageStatus.delivered:
        return Colors.grey.shade600;
      case MessageStatus.read:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (message.isMe) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade600,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(18),
                        topRight: const Radius.circular(18),
                        bottomLeft: const Radius.circular(18),
                        bottomRight: isGrouped
                            ? const Radius.circular(4)
                            : const Radius.circular(18),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          message.text,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _formatTime(message.timestamp),
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              _getStatusIcon(message.status),
                              size: 14,
                              color: _getStatusColor(message.status),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (showAvatar && !isGrouped) ...[
              const SizedBox(width: 8),
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.grey.shade300,
                child: const Icon(Icons.person, size: 18, color: Colors.black),
              ),
            ] else if (!showAvatar && !isGrouped)
              const SizedBox(width: 40),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (showAvatar && !isGrouped)
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.grey.shade300,
                backgroundImage: senderAvatar != null
                    ? NetworkImage(senderAvatar!)
                    : null,
                child: senderAvatar == null
                    ? const Icon(Icons.person, size: 18, color: Colors.black)
                    : null,
              ),
            if (showAvatar && !isGrouped) const SizedBox(width: 8),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isGrouped && senderName != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 4, bottom: 4),
                      child: Text(
                        senderName!,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(18),
                        topRight: const Radius.circular(18),
                        bottomLeft: isGrouped
                            ? const Radius.circular(4)
                            : const Radius.circular(18),
                        bottomRight: const Radius.circular(18),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message.text,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 15,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatTime(message.timestamp),
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (!showAvatar && !isGrouped) const SizedBox(width: 40),
          ],
        ),
      );
    }
  }
}

class DateDivider extends StatelessWidget {
  final DateTime date;

  const DateDivider({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final messageDate = DateTime(date.year, date.month, date.day);

      String dateText;
      if (messageDate == today) {
        dateText = 'Today';
      } else if (messageDate == today.subtract(const Duration(days: 1))) {
        dateText = 'Yesterday';
      } else {
        dateText = DateFormat('MMMM d, yyyy').format(date);
      }

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Expanded(child: Divider(color: Colors.grey.shade300)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                dateText,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(child: Divider(color: Colors.grey.shade300)),
          ],
        ),
      );
    } catch (e) {
      // Fallback if date formatting fails
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Expanded(child: Divider(color: Colors.grey.shade300)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                DateFormat('MMM d, yyyy').format(date),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(child: Divider(color: Colors.grey.shade300)),
          ],
        ),
      );
    }
  }
}

class TypingIndicator extends StatelessWidget {
  const TypingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.grey.shade300,
            child: const Icon(Icons.person, size: 18, color: Colors.black),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDot(0),
                const SizedBox(width: 4),
                _buildDot(1),
                const SizedBox(width: 4),
                _buildDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1200),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        final delay = index * 0.2;
        final animationValue = ((value + delay) % 1.0);
        final opacity = animationValue < 0.5
            ? animationValue * 2
            : 2 - (animationValue * 2);
        return Opacity(
          opacity: opacity,
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.grey.shade600,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String? chatUserId;
  final String? chatUserName;
  final String? chatUserAvatar;
  final bool isOnline;

  const ChatScreen({
    super.key,
    this.chatUserId,
    this.chatUserName,
    this.chatUserAvatar,
    this.isOnline = false,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  bool _isTyping = false;

  // Sample chat data - in a real app, this would come from a service
  final String _otherUserName = "Sarah Jenkins";
  final String _otherUserAvatar = ""; // Use fallback icon when empty

  List<ChatMessage> _messages = [
    ChatMessage(
      text: "Hi Abdullah 👋",
      isMe: false,
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      status: MessageStatus.read,
    ),
    ChatMessage(
      text: "Hello! How are you?",
      isMe: true,
      timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 1)),
      status: MessageStatus.read,
    ),
    ChatMessage(
      text:
          "I'm doing great! Thanks for asking. I saw your skill exchange offer for UI Design. I'm really interested!",
      isMe: false,
      timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
      status: MessageStatus.read,
    ),
    ChatMessage(
      text:
          "That's wonderful! I'd be happy to help you with UI Design. Are you available for a session this weekend?",
      isMe: true,
      timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 25)),
      status: MessageStatus.read,
    ),
    ChatMessage(
      text: "Yes, Saturday afternoon works perfectly for me!",
      isMe: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
      status: MessageStatus.read,
    ),
  ];

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    final message = ChatMessage(
      text: _controller.text.trim(),
      isMe: true,
      timestamp: DateTime.now(),
      status: MessageStatus.sending,
      messageId: DateTime.now().millisecondsSinceEpoch.toString(),
    );

    setState(() {
      _messages.add(message);
    });

    _controller.clear();
    _scrollToBottom();

    // Simulate message sending
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          final index = _messages.indexWhere(
            (m) => m.messageId == message.messageId,
          );
          if (index != -1) {
            _messages[index] = ChatMessage(
              text: message.text,
              isMe: message.isMe,
              timestamp: message.timestamp,
              status: MessageStatus.sent,
              messageId: message.messageId,
            );
          }
        });
      }
    });

    // Simulate message delivery
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          final index = _messages.indexWhere(
            (m) => m.messageId == message.messageId,
          );
          if (index != -1) {
            _messages[index] = ChatMessage(
              text: message.text,
              isMe: message.isMe,
              timestamp: message.timestamp,
              status: MessageStatus.delivered,
              messageId: message.messageId,
            );
          }
        });
      }
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  bool _shouldShowAvatar(int index) {
    if (index == 0) return true;
    final current = _messages[index];
    final previous = _messages[index - 1];
    return current.isMe != previous.isMe ||
        current.timestamp.difference(previous.timestamp).inMinutes > 5;
  }

  bool _isGrouped(int index) {
    if (index == 0) return false;
    final current = _messages[index];
    final previous = _messages[index - 1];
    return current.isMe == previous.isMe &&
        current.timestamp.difference(previous.timestamp).inMinutes <= 5;
  }

  bool _shouldShowDateDivider(int index) {
    if (index == 0) return true;
    final current = _messages[index];
    final previous = _messages[index - 1];
    final currentDate = DateTime(
      current.timestamp.year,
      current.timestamp.month,
      current.timestamp.day,
    );
    final previousDate = DateTime(
      previous.timestamp.year,
      previous.timestamp.month,
      previous.timestamp.day,
    );
    return currentDate != previousDate;
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatUserName = widget.chatUserName ?? _otherUserName;
    final chatUserAvatar = widget.chatUserAvatar ?? _otherUserAvatar;
    final isOnline = widget.isOnline;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage: chatUserAvatar.trim().isNotEmpty
                      ? NetworkImage(chatUserAvatar)
                      : null,
                  child: chatUserAvatar.trim().isEmpty
                      ? const Icon(Icons.person, color: Colors.black)
                      : null,
                ),
                if (isOnline)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 12,
                      height: 12,
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chatUserName,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    isOnline ? 'Online' : 'Offline',
                    style: TextStyle(
                      color: isOnline ? Colors.green : Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.phone, color: Colors.black),
            onPressed: () {},
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'view_profile',
                child: Row(
                  children: [
                    Icon(Icons.person, size: 20),
                    SizedBox(width: 8),
                    Text('View Profile'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'skill_exchange',
                child: Row(
                  children: [
                    Icon(Icons.swap_horiz, size: 20),
                    SizedBox(width: 8),
                    Text('Skill Exchange'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'clear_chat',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, size: 20, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Clear Chat', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isTyping) {
                  return const TypingIndicator();
                }

                final message = _messages[index];
                final showAvatar = _shouldShowAvatar(index);
                final isGrouped = _isGrouped(index);
                final showDateDivider = _shouldShowDateDivider(index);

                return Column(
                  children: [
                    if (showDateDivider) DateDivider(date: message.timestamp),
                    ChatBubble(
                      message: message,
                      senderName: message.isMe ? null : chatUserName,
                      senderAvatar: message.isMe ? null : chatUserAvatar,
                      showAvatar: showAvatar,
                      isGrouped: isGrouped,
                    ),
                  ],
                );
              },
            ),
          ),

          // Input Field
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.add_circle_outline,
                        color: Colors.grey.shade600,
                      ),
                      onPressed: () {
                        // Show attachment options
                      },
                    ),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        onSubmitted: (_) => _sendMessage(),
                        onChanged: (text) {
                          // Could implement typing indicator here
                        },
                        maxLines: null,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          hintText: "Type a message...",
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blue.shade600,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.send, color: Colors.white),
                        onPressed: _sendMessage,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
