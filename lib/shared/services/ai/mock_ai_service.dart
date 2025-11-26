class MockAiService {
  /// Generate financial insights based on spending data
  Future<List<String>> generateInsights({
    required double totalExpenses,
    required double totalIncome,
    required Map<String, double> categorySpending,
  }) async {
    // Simulate AI processing delay
    await Future.delayed(const Duration(seconds: 1));

    final insights = <String>[];
    final savingsRate = totalIncome > 0 
        ? ((totalIncome - totalExpenses) / totalIncome) * 100 
        : 0;

    // Savings insights
    if (savingsRate < 10) {
      insights.add('💡 Your savings rate is ${savingsRate.toStringAsFixed(1)}%. Try to save at least 20% of your income for financial security.');
    } else if (savingsRate > 30) {
      insights.add('🎉 Excellent! You\'re saving ${savingsRate.toStringAsFixed(1)}% of your income. Keep up the great work!');
    }

    // Category-specific insights
    if (categorySpending.isNotEmpty) {
      final sortedCategories = categorySpending.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      final topCategory = sortedCategories.first;
      final topPercentage = (topCategory.value / totalExpenses) * 100;

      if (topPercentage > 40) {
        insights.add('⚠️ ${topCategory.key} accounts for ${topPercentage.toStringAsFixed(0)}% of your spending. Consider reviewing this category for potential savings.');
      }

      // Food spending
      if (categorySpending.containsKey('food') && categorySpending['food']! / totalExpenses > 0.25) {
        insights.add('🍽️ Food expenses are higher than recommended. Try meal planning and cooking at home to reduce costs.');
      }
    }

    // Income vs expenses
    if (totalExpenses > totalIncome) {
      final deficit = totalExpenses - totalIncome;
      insights.add('🚨 You\'re spending \$${deficit.toStringAsFixed(2)} more than you earn. Review your budget urgently.');
    }

    // General tips
    insights.add('💰 Consider setting up automatic transfers to your savings account on payday.');
    insights.add('📊 Track your expenses daily to stay aware of your spending patterns.');

    return insights;
  }

  /// Generate AI chat response (mock)
  Future<String> getChatResponse(String userMessage) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final lower = userMessage.toLowerCase();

    if (lower.contains('save') || lower.contains('savings')) {
      return 'Great question about savings! I recommend following the 50/30/20 rule: 50% for needs, 30% for wants, and 20% for savings. Start by automating your savings with automatic transfers on payday.';
    } else if (lower.contains('budget')) {
      return 'Creating a budget is essential! Start by tracking all your expenses for a month, then categorize them. Set limits for each category based on your income and goals. I can help you analyze your spending patterns.';
    } else if (lower.contains('debt') || lower.contains('loan')) {
      return 'For managing debt, I suggest the debt avalanche method: pay minimum on all debts, then put extra money toward the highest interest rate debt. This saves you the most money long-term.';
    } else if (lower.contains('invest')) {
      return 'Investing is great for long-term wealth! Before investing, make sure you have an emergency fund (3-6 months of expenses) and are managing any high-interest debt. Consider starting with low-cost index funds.';
    } else if (lower.contains('hello') || lower.contains('hi')) {
      return 'Hello! I\'m your AI financial assistant. I can help you with budgeting, saving strategies, debt management, and general financial advice. How can I assist you today?';
    } else if (lower.contains('spend') || lower.contains('expense')) {
      return 'Based on your spending patterns, I notice opportunities to optimize. Review your discretionary spending and look for subscriptions you might not be using. Small daily savings add up significantly over time!';
    }

    return 'I understand you\'re asking about "$userMessage". While I\'m a mock AI assistant for now, in the full version I\'ll provide personalized financial advice based on your actual spending data. Is there anything specific about budgeting or saving I can help with?';
  }

  /// Get spending recommendations
  Future<List<String>> getSpendingRecommendations(Map<String, double> categorySpending) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final recommendations = <String>[];

    // Analyze each category
    categorySpending.forEach((category, amount) {
      if (category == 'food' && amount > 500) {
        recommendations.add('Consider meal prep to reduce food costs by 30-40%');
      } else if (category == 'entertainment' && amount > 200) {
        recommendations.add('Look for free entertainment options like parks, libraries, and community events');
      } else if (category == 'transport' && amount > 300) {
        recommendations.add('Explore public transport or carpooling to save on gas');
      }
    });

    if (recommendations.isEmpty) {
      recommendations.add('Your spending looks balanced! Keep tracking to maintain this.');
    }

    return recommendations;
  }
}
