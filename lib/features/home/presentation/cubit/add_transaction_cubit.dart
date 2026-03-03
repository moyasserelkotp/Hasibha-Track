import '../../domain/usecases/create_transaction_usecase.dart';
import 'add_transaction_state.dart';

class AddTransactionCubit extends Cubit<AddTransactionState> {
  final CreateTransactionUseCase createTransactionUseCase;

  AddTransactionCubit({required this.createTransactionUseCase}) : super(AddTransactionInitial());

  Future<void> addTransaction({
    required String title,
    required double amount,
    required String category,
    required String type,
    required DateTime date,
    String? description,
    String? icon,
    String? notes,
    String? paymentMethod,
    List<String>? tags,
  }) async {
    emit(AddTransactionLoading());

    final result = await createTransactionUseCase(
      type: type,
      amount: amount,
      category: category,
      description: title.isNotEmpty ? title : description,
      date: date.toIso8601String(),
      notes: notes,
      paymentMethod: paymentMethod,
      tags: tags,
    );

    result.fold(
      (failure) => emit(AddTransactionError(failure.message)),
      (_) => emit(AddTransactionSuccess()),
    );
  }

  void reset() {
    emit(AddTransactionInitial());
  }
}
