/// Paginated data wrapper
class PaginatedData<T> {
  final List<T> items;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int pageSize;
  final bool hasNextPage;
  final bool hasPreviousPage;

  const PaginatedData({
    required this.items,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.pageSize,
  })  : hasNextPage = currentPage < totalPages,
        hasPreviousPage = currentPage > 1;

  /// Create empty paginated data
  factory PaginatedData.empty() {
    return const PaginatedData(
      items: [],
      currentPage: 1,
      totalPages: 1,
      totalItems: 0,
      pageSize: 20,
    );
  }

  /// Create from list with pagination
  factory PaginatedData.fromList({
    required List<T> allItems,
    required int page,
    int pageSize = 20,
  }) {
    final totalItems = allItems.length;
    final totalPages = (totalItems / pageSize).ceil();
    final startIndex = (page - 1) * pageSize;
    final endIndex = (startIndex + pageSize).clamp(0, totalItems);

    final items = startIndex < totalItems
        ? allItems.sublist(startIndex, endIndex)
        : <T>[];

    return PaginatedData(
      items: items,
      currentPage: page,
      totalPages: totalPages > 0 ? totalPages : 1,
      totalItems: totalItems,
      pageSize: pageSize,
    );
  }

  /// Append more items (for infinite scroll)
  PaginatedData<T> appendItems(PaginatedData<T> nextPage) {
    return PaginatedData(
      items: [...items, ...nextPage.items],
      currentPage: nextPage.currentPage,
      totalPages: nextPage.totalPages,
      totalItems: nextPage.totalItems,
      pageSize: pageSize,
    );
  }

  /// Get page info
  String get pageInfo => 'Page $currentPage of $totalPages';

  /// Get items info
  String get itemsInfo {
    final start = items.isEmpty ? 0 : (currentPage - 1) * pageSize + 1;
    final end = (currentPage - 1) * pageSize + items.length;
    return 'Showing $start-$end of $totalItems';
  }

  @override
  String toString() {
    return 'PaginatedData(items: ${items.length}, page: $currentPage/$totalPages, total: $totalItems)';
  }
}

/// Pagination parameters
class PaginationParams {
  final int page;
  final int pageSize;
  final String? sortBy;
  final bool ascending;

  const PaginationParams({
    this.page = 1,
    this.pageSize = 20,
    this.sortBy,
    this.ascending = true,
  });

  PaginationParams copyWith({
    int? page,
    int? pageSize,
    String? sortBy,
    bool? ascending,
  }) {
    return PaginationParams(
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      sortBy: sortBy ?? this.sortBy,
      ascending: ascending ?? this.ascending,
    );
  }

  /// Next page
  PaginationParams nextPage() => copyWith(page: page + 1);

  /// Previous page
  PaginationParams previousPage() => copyWith(page: page > 1 ? page - 1 : 1);

  /// First page
  PaginationParams firstPage() => copyWith(page: 1);

  Map<String, dynamic> toJson() => {
        'page': page,
        'pageSize': pageSize,
        if (sortBy != null) 'sortBy': sortBy,
        'ascending': ascending,
      };

  @override
  String toString() => 'PaginationParams(page: $page, pageSize: $pageSize)';
}
