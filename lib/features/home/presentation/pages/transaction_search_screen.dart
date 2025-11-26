import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../di/injection.dart' as di;
import '../../../../shared/utils/debouncer.dart';
import '../../../../shared/services/logger_service.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/home_repository.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';

/// Search transactions screen with debouncing
class TransactionSearchScreen extends StatefulWidget {
  const TransactionSearchScreen({super.key});

  @override
  State<TransactionSearchScreen> createState() => _TransactionSearchScreenState();
}

class _TransactionSearchScreenState extends State<TransactionSearchScreen> {
  final _searchController = TextEditingController();
  final _debouncer = Debouncer(duration: const Duration(milliseconds: 500));
  final _logger = Logger.get('TransactionSearch');

  List<Transaction> _filteredTransactions = [];
  List<Transaction> _allTransactions = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loadTransactions();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  Future<void> _loadTransactions() async {
    // Load all transactions from cubit state
    final state = context.read<HomeCubit>().state;
    if (state is HomeLoaded) {
      setState(() {
        _allTransactions = state.dashboardSummary.recentTransactions;
        _filteredTransactions = _allTransactions;
      });
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text;

    // Debounce the search
    _debouncer.call(() {
      _logger.info('Searching for: $query');
      _performSearch(query);
    });

    // Show searching indicator immediately
    if (query.isNotEmpty && !_isSearching) {
      setState(() => _isSearching = true);
    }
  }

  void _performSearch(String query) {
    _logger.debug('Performing search with query: $query');

    if (query.isEmpty) {
      setState(() {
        _filteredTransactions = _allTransactions;
        _isSearching = false;
      });
      return;
    }

    final lowercaseQuery = query.toLowerCase();
    final results = _allTransactions.where((transaction) {
      return transaction.title.toLowerCase().contains(lowercaseQuery) ||
          transaction.category.toLowerCase().contains(lowercaseQuery) ||
          transaction.description?.toLowerCase().contains(lowercaseQuery) == true;
    }).toList();

    _logger.info('Found ${results.length} results for query: $query');

    setState(() {
      _filteredTransactions = results;
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search transactions...',
            border: InputBorder.none,
            suffix: _isSearching
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : null,
          ),
          autofocus: true,
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                _performSearch('');
              },
            ),
        ],
      ),
      body: ListView.builder(
        itemCount: _filteredTransactions.length,
        itemBuilder: (context, index) {
          final transaction = _filteredTransactions[index];
          return ListTile(
            title: Text(transaction.title),
            subtitle: Text(transaction.category),
            trailing: Text(
              '\$${transaction.amount.toStringAsFixed(2)}',
              style: TextStyle(
                color: transaction.type == 'income' ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      ),
    );
  }
}
