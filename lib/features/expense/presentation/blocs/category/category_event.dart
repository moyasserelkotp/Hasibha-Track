import 'package:equatable/equatable.dart';
import '../../../domain/entities/expense_category.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object?> get props => [];
}

class LoadCategories extends CategoryEvent {
  const LoadCategories();
}

class CreateCategory extends CategoryEvent {
  final ExpenseCategory category;

  const CreateCategory(this.category);

  @override
  List<Object?> get props => [category];
}
