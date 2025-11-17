// lib/widgets/chat_window.dart

import 'package:flutter/material.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import '/home/chat bot/chat_service.dart'; // Make sure this path is correct

class ChatWindow extends StatefulWidget {
  final ChatService chatService;

  const ChatWindow({super.key, required this.chatService});

  @override
  State<ChatWindow> createState() => _ChatWindowState();
}

class _ChatWindowState extends State<ChatWindow> {
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, String>> _chatMessages = [];
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _chatMessages.add({'from': 'bot', 'text': 'Hello! How can I help you?'});
  }

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
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    _chatController.clear();

    try {
      final reply = await widget.chatService.sendMessage(message);
      setState(() {
        _chatMessages.add({'from': 'bot', 'text': reply});
      });
    } catch (e) {
      setState(() {
        _chatMessages.add({'from': 'bot', 'text': 'Error: Could not reach the server. Please check your connection.'});
      });
    } finally {
      setState(() {
        _isSending = false;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Use a SizedBox to constrain the height of the chat window
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      width: double.maxFinite, // Occupy the full width of the dialog
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(12),
              itemCount: _chatMessages.length,
              itemBuilder: (context, idx) {
                final m = _chatMessages[idx];
                final fromUser = m['from'] == 'user';

                if (!fromUser) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CircleAvatar(
                          backgroundColor: Colors.blueGrey,
                          child: Icon(Icons.support_agent, color: Colors.white),
                        ),
                        const SizedBox(width: 8),
                        // <-- FIX: Wrap the BubbleSpecialThree with Expanded -->
                        Expanded(
                          child: BubbleSpecialThree(
                            text: m['text'] ?? '',
                            color: theme.cardColor,
                            tail: true,
                            isSender: false,
                            textStyle: TextStyle(color: theme.textTheme.bodyLarge?.color, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // For user messages, bubble is on the right
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
                      hintText: 'Ask me anything...',
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
    );
  }
}