import '../../features/offers/domain/entities/offer.dart';

class RecommendationEngine {
  /// Generate personalized offers based on user spending
  List<Offer> generatePersonalizedOffers({
    required Map<String, double> userSpending,
    required List<String> frequentMerchants,
  }) {
    final offers = <Offer>[];
    final now = DateTime.now();

    // Analyze top spending categories
    final sortedCategories = userSpending.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    for (final entry in sortedCategories.take(3)) {
      final category = entry.key;
      final spending = entry.value;

      // Generate category-specific offers
      if (category == 'food' && spending > 200) {
        offers.add(Offer(
          id: 'offer_food_1',
          title: '20% Off Food Delivery',
          description: 'Save 20% on your next food delivery order. Valid for orders over \$25.',
          type: OfferType.DISCOUNT,
          category: 'food',
          merchantName: 'DeliveryApp',
          discountPercentage: 20,
          validUntil: now.add(const Duration(days: 7)),
          isPersonalized: true,
          relevanceScore: 85,
          tags: ['food', 'delivery', 'popular'],
        ));
      }

      if (category == 'shopping' && spending > 150) {
        offers.add(Offer(
          id: 'offer_shop_1',
          title: '\$10 Cashback on Shopping',
          description: 'Get \$10 cashback when you spend \$50 or more.',
          type: OfferType.CASHBACK,
          category: 'shopping',
          merchantName: 'OnlineRetailer',
          discountPercentage: 0,
          discountAmount: '\$10',
          validUntil: now.add(const Duration(days: 14)),
          isPersonalized: true,
          relevanceScore: 80,
          tags: ['cashback', 'shopping'],
        ));
      }

      if (category == 'transport' && spending > 100) {
        offers.add(Offer(
          id: 'offer_transport_1',
          title: '15% Off Gas Stations',
          description: 'Save15% on gas purchases at participating stations.',
          type: OfferType.DISCOUNT,
          category: 'transport',
          merchantName: 'GasRewards',
          discountPercentage: 15,
          validUntil: now.add(const Duration(days: 30)),
          isPersonalized: true,
          relevanceScore: 75,
          tags: ['gas', 'savings'],
        ));
      }
    }

    // Add general offers
    offers.addAll(_getGeneralOffers(now));

    // Sort by relevance score
    offers.sort((a, b) => b.relevanceScore.compareTo(a.relevanceScore));

    return offers;
  }

  /// Get general (non-personalized) offers
  List<Offer> _getGeneralOffers(DateTime now) {
    return [
      Offer(
        id: 'offer_general_1',
        title: '5% Cashback on All Purchases',
        description: 'Earn 5% cashback on all purchases made this month.',
        type: OfferType.CASHBACK,
        category: 'all',
        merchantName: 'CashbackCard',
        discountPercentage: 5,
        validUntil: now.add(const Duration(days: 30)),
        isPersonalized: false,
        relevanceScore: 60,
        tags: ['cashback', 'general'],
      ),
      Offer(
        id: 'offer_general_2',
        title: 'Free Shipping Weekend',
        description: 'Get free shipping on all online orders this weekend.',
        type: OfferType.DEAL,
        category: 'shopping',
        merchantName: 'Various Retailers',
        discountPercentage: 0,
        validUntil: now.add(const Duration(days: 3)),
        isPersonalized: false,
        relevanceScore: 55,
        tags: ['shipping', 'weekend'],
      ),
      Offer(
        id: 'offer_general_3',
        title: 'Double Points on Dining',
        description: 'Earn double reward points at all restaurants.',
        type: OfferType.REWARD,
        category: 'food',
        merchantName: 'RewardsProgram',
        discountPercentage: 0,
        validUntil: now.add(const Duration(days: 21)),
        isPersonalized: false,
        relevanceScore: 50,
        tags: ['rewards', 'dining'],
      ),
    ];
  }

  /// Calculate relevance score based on user behavior
  double calculateRelevanceScore({
    required Offer offer,
    required Map<String, double> userSpending,
  }) {
    double score = 50.0; // Base score

    // Boost if category matches user's top spending
    if (userSpending.containsKey(offer.category)) {
      final categorySpending = userSpending[offer.category]!;
      final totalSpending = userSpending.values.reduce((a, b) => a + b);
      final categoryPercentage = (categorySpending / totalSpending) * 100;

      score += categoryPercentage; // Up to +100 for heavily used categories
    }

    // Boost for higher discount percentages
    score += offer.discountPercentage * 0.5; // Up to +50 for 100% discount

    // Penalty for expiring soon if not urgent
    if (offer.isExpiringSoon) {
      score += 10; // Slight boost for urgency
    }

    // Penalty for expired offers
    if (offer.isExpired) {
      score = 0;
    }

    return score.clamp(0, 100);
  }
}
