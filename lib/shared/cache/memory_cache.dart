import 'dart:async';
import 'dart:convert';

/// Cache entry with expiration time
class CacheEntry<T> {
  final T value;
  final DateTime expiresAt;

  CacheEntry(this.value, this.expiresAt);

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  Map<String, dynamic> toJson() => {
        'value': value,
        'expiresAt': expiresAt.toIso8601String(),
      };

  factory CacheEntry.fromJson(Map<String, dynamic> json, T Function(dynamic) fromJsonT) {
    return CacheEntry(
      fromJsonT(json['value']),
      DateTime.parse(json['expiresAt']),
    );
  }
}

/// In-memory LRU cache
class MemoryCache<T> {
  final int maxSize;
  final Map<String, CacheEntry<T>> _cache = {};
  final List<String> _accessOrder = [];

  MemoryCache({this.maxSize = 100});

  /// Get value from cache
  T? get(String key) {
    final entry = _cache[key];
    if (entry == null || entry.isExpired) {
      _cache.remove(key);
      _accessOrder.remove(key);
      return null;
    }

    // Update access order (LRU)
    _accessOrder.remove(key);
    _accessOrder.add(key);

    return entry.value;
  }

  /// Put value in cache
  void put(String key, T value, {Duration ttl = const Duration(minutes: 5)}) {
    final expiresAt = DateTime.now().add(ttl);
    _cache[key] = CacheEntry(value, expiresAt);

    _accessOrder.remove(key);
    _accessOrder.add(key);

    _evictIfNecessary();
  }

  /// Remove value from cache
  void remove(String key) {
    _cache.remove(key);
    _accessOrder.remove(key);
  }

  /// Clear all cache
  void clear() {
    _cache.clear();
    _accessOrder.clear();
  }

  /// Check if key exists and not expired
  bool has(String key) {
    return get(key) != null;
  }

  /// Evict oldest entries if cache is full
  void _evictIfNecessary() {
    while (_cache.length > maxSize) {
      final oldestKey = _accessOrder.first;
      _cache.remove(oldestKey);
      _accessOrder.removeAt(0);
    }
  }

  /// Get cache statistics
  Map<String, dynamic> get stats => {
        'size': _cache.length,
        'maxSize': maxSize,
        'hitRate': _calculateHitRate(),
      };

  double _calculateHitRate() {
    // Simple hit rate calculation
    return _cache.isEmpty ? 0.0 : _cache.length / maxSize;
  }
}
