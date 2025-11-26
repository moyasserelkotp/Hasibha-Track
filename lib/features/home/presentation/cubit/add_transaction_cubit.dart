import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/usecases/add_transaction_usecase.dart';
import 'add_transaction_state.dart';

class AddTransactionCubit extends Cubit<AddTransactionState> {
  final AddTransactionUseCase addTransactionUseCase;

  AddTransactionCubit(this.addTransactionUseCase) : super(AddTransactionInitial());

  Future<void> addTransaction({
    required String title,
    required double amount,
    required String category,
    required String type,
    required DateTime date,
    String? description,
    String? icon,
  }) async {
    emit(AddTransactionLoading());

    final transaction = Transaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      amount: amount,
      category: category,
      type: type,
      date: date,
      description: description,
      icon: icon,
    );

    final result = await addTransactionUseCase(transaction);

    result.fold(
      (failure) => emit(AddTransactionError(failure.message)),
      (_) => emit(AddTransactionSuccess()),
    );
  }

  void reset() {
    emit(AddTransactionInitial());
  }
}
