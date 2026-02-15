import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/services.dart';

class ChatProvider extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  List<EventModel> _events = [];
  List<MessageModel> _messages = [];
  bool _isLoading = false;
  String? _error;

  List<EventModel> get events => _events;
  List<MessageModel> get messages => _messages;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Stream<List<EventModel>>? _eventsStream;
  Stream<List<MessageModel>>? _messagesStream;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setError(String? value) {
    _error = value;
    notifyListeners();
  }

  void listenToEvents(String userId) {
    _eventsStream = _databaseService.getUserEventsStream(userId);
    _eventsStream?.listen((events) {
      _events = events;
      notifyListeners();
    });
  }

  void listenToMessages(String chatRoomId) {
    _messagesStream = _databaseService.getChatMessagesStream(chatRoomId);
    _messagesStream?.listen((messages) {
      _messages = messages;
      notifyListeners();
    });
  }

  Future<void> joinEvent(String eventId, String userId) async {
    try {
      setLoading(true);
      await _databaseService.joinEvent(eventId, userId);
      setLoading(false);
    } catch (e) {
      setLoading(false);
      setError(e.toString());
    }
  }

  Future<void> sendMessage(String chatRoomId, String text, String senderId, String senderName) async {
    try {
      MessageModel message = MessageModel(
        senderId: senderId,
        senderName: senderName,
        text: text,
        timestamp: DateTime.now(),
      );
      await _databaseService.sendMessage(chatRoomId, message);
    } catch (e) {
      setError(e.toString());
    }
  }
}