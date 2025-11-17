import 'package:flutter/services.dart' show rootBundle;
import 'package:google_generative_ai/google_generative_ai.dart';

/// A service class to handle chat interactions with the Gemini model.
class ChatService {
  ChatSession? _chatSession;

  /// The Gemini API key, passed during instantiation.
  final String _apiKey;

  // Constructor requires the API key.
  ChatService({required String apiKey}) : _apiKey = 'AIzaSyBT-g4A2GQhPm4pbMe5Pwe2bCtHf8Owgl8';

  /// Returns true if the chat service has been successfully initialized.
  bool get isInitialized => _chatSession != null;

  /// Initializes the Gemini model and starts a chat session.
  /// It loads the FAQ content from assets for strict context adherence.
  Future<bool> initialize() async {
    try {
      if (_apiKey.trim().isEmpty) {
        print("API key is missing. Initialization failed.");
        return false;
      }

      // Load the FAQ content from the application's assets
      final faqContent = await rootBundle.loadString('assets/FAQ.json');
      print('FAQ content loaded successfully.');

      // Define the system instruction for the model
      final systemInstruction = Content.system(
        """
        Act as NirwanaGrid Assistant Bot and strictly use the provided FAQ content to answer queries of the user.

        Here is the FAQ content in JSON format:
        $faqContent
        """
      );

      // Create the model instance with the corrected parameter usage for SDK v0.4.7
      final model = GenerativeModel(
        // Using 'gemini-2.5-flash' for the current generation model.
        model: 'gemini-2.5-flash', 
        apiKey: _apiKey.trim(),
        
        // FIX: The 'systemInstruction' parameter is passed directly to the 
        // GenerativeModel constructor in SDK version 0.4.7, not inside 'config'.
        systemInstruction: systemInstruction,
      );

      _chatSession = model.startChat();
      print('Chat session initialized successfully.');
      return true;
    } catch (e) {
      print('Failed to initialize ChatService: $e');
      _chatSession = null;
      return false;
    }
  }

  /// Sends a message to the Gemini chat session and returns the bot's reply.
  Future<String> sendMessage(String message) async {
    // Attempt initialization if not ready (your original logic)
    if (_chatSession == null) {
      final success = await initialize();
      if (!success) {
        return 'Error: Chat service is not initialized. Please check your API key and network.';
      }
    }

    try {
      final response = await _chatSession!.sendMessage(Content.text(message));
      final botReply = response.text;

      if (botReply == null || botReply.isEmpty) {
        return 'Sorry, I could not process that.';
      }
      return botReply;
    } catch (e) {
      print('Error sending message: $e');
      return 'Error: Could not reach the server. Please check your connection.';
    }
  }
}
