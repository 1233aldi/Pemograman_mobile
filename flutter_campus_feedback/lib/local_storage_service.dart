import 'package:shared_preferences/shared_preferences.dart';
import 'model/feedback_item.dart';

class LocalStorageService {
  static const String _feedbackKey = 'feedback_items';

  static Future<void> saveFeedbackItems(List<FeedbackItem> items) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> jsonItems = items.map((item) => item.toJson()).toList();
      await prefs.setStringList(_feedbackKey, jsonItems);
    } catch (e) {
      print('Error saving feedback: $e');
    }
  }

  static Future<List<FeedbackItem>> loadFeedbackItems() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String>? jsonItems = prefs.getStringList(_feedbackKey);
      
      if (jsonItems == null) return [];
      
      return jsonItems.map((jsonString) {
        return FeedbackItem.fromJson(jsonString);
      }).toList();
    } catch (e) {
      print('Error loading feedback: $e');
      return [];
    }
  }

  static Future<void> clearFeedbackItems() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_feedbackKey);
    } catch (e) {
      print('Error clearing feedback: $e');
    }
  }
}