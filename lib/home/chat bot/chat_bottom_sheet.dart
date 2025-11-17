import 'package:flutter/material.dart';
import 'package:chat_bubbles/chat_bubbles.dart'; // <-- 1. Import the package
import '/home/chat bot/chat_service.dart';

class ChatBottomSheet extends StatefulWidget {
  final ChatService chatService;

  const ChatBottomSheet({super.key, required this.chatService});

  @override
  State<ChatBottomSheet> createState() => _ChatBottomSheetState();
}

class _ChatBottomSheetState extends State<ChatBottomSheet> {
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _scrollController = ScrollController(); // <-- 2. Add a Scroll Controller
  final List<Map<String, String>> _chatMessages = [];
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _chatMessages.add({'from': 'bot', 'text': 'Hello! How can I help you control your home?'});
  }

  // This function will scroll to the bottom of the list
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _sendMessage() async {
    final message = _chatController.text.trim();
    if (message.isEmpty) return;

    setState(() {
      _chatMessages.add({'from': 'user', 'text': message});
      _isSending = true;
    });
    // Scroll after adding user message
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    _chatController.clear();

    try {
      final reply = await widget.chatService.sendMessage(message);
      setState(() {
        _chatMessages.add({'from': 'bot', 'text': reply});
      });
    } catch (e) {
      setState(() {
        _chatMessages.add({'from': 'bot', 'text': 'Error: ${e.toString()}'});
      });
    } finally {
      setState(() {
        _isSending = false;
      });
       // Scroll after getting bot reply
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.55,
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 48,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                // <-- 3. THIS IS THE MAIN UI CHANGE
                child: ListView.builder(
                  controller: _scrollController, // Assign the controller
                  padding: const EdgeInsets.all(12),
                  itemCount: _chatMessages.length,
                  itemBuilder: (context, idx) {
                    final m = _chatMessages[idx];
                    final fromUser = m['from'] == 'user';

                    // For bot messages, show avatar and bubble
                    if (!fromUser) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // The Bot Avatar
                          const CircleAvatar(
                            backgroundColor: Colors.blueGrey,
                            child: Icon(Icons.support_agent, color: Colors.white),
                          ),
                          const SizedBox(width: 8),
                          // The Chat Bubble with a tail
                          BubbleSpecialThree(
                            text: m['text'] ?? '',
                            color: theme.cardColor,
                            tail: true,
                            isSender: false,
                            textStyle: TextStyle(color: theme.textTheme.bodyLarge?.color, fontSize: 16),
                          ),
                        ],
                      );
                    }

                    // For user messages, show only the bubble on the right
                    return BubbleSpecialThree(
                      text: m['text'] ?? '',
                      color: theme.colorScheme.primary.withOpacity(0.95),
                      tail: true,
                      isSender: true,
                      textStyle: const TextStyle(color: Colors.white, fontSize: 16),
                    );
                  },
                ),
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _chatController,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: const InputDecoration(
                          hintText: 'e.g., "Turn on the AC"',
                          border: InputBorder.none,
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                    _isSending
                        ? const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                          )
                        : IconButton(
                            onPressed: _sendMessage,
                            icon: const Icon(Icons.send),
                          ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}