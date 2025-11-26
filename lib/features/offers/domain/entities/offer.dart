import 'package:equatable/equatable.dart';

enum OfferType {
  CASHBACK,
  DISCOUNT,
  REWARD,
  DEAL,
}

class Offer extends Equatable {
  final String id;
  final String title;
  final String description;
  final OfferType type;
  final String category;
  final String merchantName;
  final double discountPercentage;
  final String? discountAmount;
  final String? imageUrl;
  final DateTime validUntil;
  final bool isPersonalized;
  final double relevanceScore; // 0-100
  final List<String> tags;

  const Offer({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.category,
    required this.merchantName,
    required this.discountPercentage,
    this.discountAmount,
    this.imageUrl,
    required this.validUntil,
    this.isPersonalized = false,
    this.relevanceScore = 50.0,
    this.tags = const [],
  });

  bool get isExpired => DateTime.now().isAfter(validUntil);
  bool get isExpiringSoon => validUntil.difference(DateTime.now()).inDays <= 3;

  Offer copyWith({
    String? id,
    String? title,
    String? description,
    OfferType? type,
    String? category,
    String? merchantName,
    double? discountPercentage,
    String? discountAmount,
    String? imageUrl,
    DateTime? validUntil,
    bool? isPersonalized,
    double? relevanceScore,
    List<String>? tags,
  }) {
    return Offer(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      category: category ?? this.category,
      merchantName: merchantName ?? this.merchantName,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      discountAmount: discountAmount ?? this.discountAmount,
      imageUrl: imageUrl ?? this.imageUrl,
      validUntil: validUntil ?? this.validUntil,
      isPersonalized: isPersonalized ?? this.isPersonalized,
      relevanceScore: relevanceScore ?? this.relevanceScore,
      tags: tags ?? this.tags,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        type,
        category,
        merchantName,
        discountPercentage,
        discountAmount,
        imageUrl,
        validUntil,
        isPersonalized,
        relevanceScore,
        tags,
      ];
}
