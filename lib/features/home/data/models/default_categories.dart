import '../models/category_model.dart';

// Default categories that will be seeded on first app launch
class DefaultCategories {
  static List<CategoryModel> get expenseCategories => [
        const CategoryModel(
          id: 'exp_food',
          name: 'Food',
          icon: '0xe3bb', // Icons.restaurant codePoint
          color: '0xFFF44336', // Red
          type: 'expense',
          isDefault: true,
          sortOrder: 1,
        ),
        const CategoryModel(
          id: 'exp_transport',
          name: 'Transportation',
          icon: '0xe531', // Icons.directions_car codePoint
          color: '0xFF2196F3', // Blue
          type: 'expense',
          isDefault: true,
          sortOrder: 2,
        ),
        const CategoryModel(
          id: 'exp_entertainment',
          name: 'Entertainment',
          icon: '0xe50b', // Icons.movie codePoint
          color: '0xFF9C27B0', // Purple
          type: 'expense',
          isDefault: true,
          sortOrder: 3,
        ),
        const CategoryModel(
          id: 'exp_shopping',
          name: 'Shopping',
          icon: '0xe59c', // Icons.shopping_bag codePoint
          color: '0xFFFF9800', // Orange
          type: 'expense',
          isDefault: true,
          sortOrder: 4,
        ),
        const CategoryModel(
          id: 'exp_bills',
          name: 'Bills',
          icon: '0xe8ca', // Icons.receipt codePoint
          color: '0xFF607D8B', // Blue Grey
          type: 'expense',
          isDefault: true,
          sortOrder: 5,
        ),
        const CategoryModel(
          id: 'exp_health',
          name: 'Health',
          icon: '0xe3b7', // Icons.local_hospital codePoint
          color: '0xFF4CAF50', // Green
          type: 'expense',
          isDefault: true,
          sortOrder: 6,
        ),
        const CategoryModel(
          id: 'exp_education',
          name: 'Education',
          icon: '0xe5ca', // Icons.school codePoint
          color: '0xFF00BCD4', //Cyan
          type: 'expense',
          isDefault: true,
          sortOrder: 7,
        ),
        const CategoryModel(
          id: 'exp_other',
          name: 'Other',
          icon: '0xe5d3', // Icons.more_horiz codePoint
          color: '0xFF9E9E9E', // Grey
          type: 'expense',
          isDefault: true,
          sortOrder: 8,
        ),
      ];

  static List<CategoryModel> get incomeCategories => [
        const CategoryModel(
          id: 'inc_salary',
          name: 'Salary',
          icon: '0xe263', // Icons.account_balance_wallet codePoint
          color: '0xFF4CAF50', // Green
          type: 'income',
          isDefault: true,
          sortOrder: 1,
        ),
        const CategoryModel(
          id: 'inc_freelance',
          name: 'Freelance',
          icon: '0xe30a', // Icons.work codePoint
          color: '0xFF2196F3', // Blue
          type: 'income',
          isDefault: true,
          sortOrder: 2,
        ),
        const CategoryModel(
          id: 'inc_investment',
          name: 'Investment',
          icon: '0xe8e8', // Icons.trending_up codePoint
          color: '0xFF9C27B0', // Purple
          type: 'income',
          isDefault: true,
          sortOrder: 3,
        ),
        const CategoryModel(
          id: 'inc_gift',
          name: 'Gift',
          icon: '0xe8f6', // Icons.card_giftcard codePoint
          color: '0xFFE91E63', // Pink
          type: 'income',
          isDefault: true,
          sortOrder: 4,
        ),
        const CategoryModel(
          id: 'inc_other',
          name: 'Other',
          icon: '0xe5d3', // Icons.more_horiz codePoint
          color: '0xFF9E9E9E', // Grey
          type: 'income',
          isDefault: true,
          sortOrder: 5,
        ),
      ];

  static List<CategoryModel> get all => [
        ...expenseCategories,
        ...incomeCategories,
      ];
}
