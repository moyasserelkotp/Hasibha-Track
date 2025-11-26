import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import 'logger_service.dart';

class VoiceInputService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final _logger = LoggerService();
  bool _isListening = false;
  bool _isAvailable = false;

  bool get isListening => _isListening;
  bool get isAvailable => _isAvailable;

  /// Initialize speech recognition
  Future<bool> initialize() async {
    try {
      // Request microphone permission
      final status = await Permission.microphone.request();
      if (!status.isGranted) {
        return false;
      }

      // Initialize speech recognition
      _isAvailable = await _speech.initialize(
        onError: (error) => _logger.error('Speech recognition error: $error'),
        onStatus: (status) => _logger.debug('Speech recognition status: $status'),
      );

      return _isAvailable;
    } catch (e) {
      _logger.error('Error initializing voice input: $e');
      return false;
    }
  }

  /// Start listening for voice input
  Future<void> startListening({
    required Function(String) onResult,
    Function(String)? onPartialResult,
  }) async {
    if (!_isAvailable) {
      final initialized = await initialize();
      if (!initialized) {
        throw Exception('Speech recognition not available');
      }
    }

    if (!_isListening) {
      _isListening = true;
      await _speech.listen(
        onResult: (result) {
          if (result.finalResult) {
            onResult(result.recognizedWords);
            _isListening = false;
          } else if (onPartialResult != null) {
            onPartialResult(result.recognizedWords);
          }
        },
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),
        partialResults: onPartialResult != null,
        cancelOnError: true,
        listenMode: stt.ListenMode.confirmation,
      );
    }
  }

  /// Stop listening
  Future<void> stopListening() async {
    if (_isListening) {
      await _speech.stop();
      _isListening = false;
    }
  }

  /// Cancel listening
  Future<void> cancelListening() async {
    if (_isListening) {
      await _speech.cancel();
      _isListening = false;
    }
  }

  /// Parse voice input for expense data
  /// Example: "I spent 50 dollars on groceries"
  Map<String, dynamic>? parseExpenseFromVoice(String text) {
    final lowerText = text.toLowerCase();
    
    // Extract amount
    double? amount;
    final amountPatterns = [
      RegExp(r'(\d+\.?\d*)\s*dollars?'),
      RegExp(r'(\d+\.?\d*)\s*bucks?'),
      RegExp(r'\$\s*(\d+\.?\d*)'),
      RegExp(r'(\d+\.?\d*)\s*(?:usd|eur|gbp)'),
    ];

    for (final pattern in amountPatterns) {
      final match = pattern.firstMatch(lowerText);
      if (match != null) {
        amount = double.tryParse(match.group(1)!);
        break;
      }
    }

    if (amount == null) {
      // Try to find any number
      final numberMatch = RegExp(r'(\d+\.?\d*)').firstMatch(lowerText);
      if (numberMatch != null) {
        amount = double.tryParse(numberMatch.group(1)!);
      }
    }

    // Extract category hints
    String? category;
    final categoryKeywords = {
      'food': ['food', 'groceries', 'restaurant', 'eating', 'lunch', 'dinner', 'breakfast'],
      'transport': ['uber', 'taxi', 'bus', 'train', 'gas', 'fuel', 'parking'],
      'entertainment': ['movie', 'cinema', 'game', 'concert', 'show'],
      'shopping': ['shopping', 'clothes', 'store', 'bought'],
      'bills': ['bill', 'electricity', 'water', 'internet', 'phone'],
      'health': ['doctor', 'medicine', 'pharmacy', 'hospital'],
    };

    for (final entry in categoryKeywords.entries) {
      if (entry.value.any((keyword) => lowerText.contains(keyword))) {
        category = entry.key;
        break;
      }
    }

    // Extract description (use original text or cleaned version)
    String description = text.trim();

    // Detect type (income vs expense)
    bool isIncome = lowerText.contains('earned') || 
                    lowerText.contains('received') || 
                    lowerText.contains('got paid') ||
                    lowerText.contains('income');

    if (amount == null) {
      return null; // Can't create expense without amount
    }

    return {
      'amount': amount,
      'category': category,
      'description': description,
      'type': isIncome ? 'income' : 'expense',
    };
  }

  void dispose() {
    _speech.stop();
  }
}
