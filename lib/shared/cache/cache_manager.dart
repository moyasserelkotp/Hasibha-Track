import 'dart:convert';
import 'package:hive/hive.dart';
import 'memory_cache.dart';

/// Cache strategy
enum CacheStrategy {
  /// Try cache first, then network
  cacheFirst,

  /// Try network first, cache on fail
  networkFirst,

  /// Only from cache
  cacheOnly,

  /// Only from network (bypass cache)
  networkOnly,
}

/// Persistent disk cache using Hive
class DiskCache {
  static const String _boxName = 'app_cache';
  Box<String>? _box;

  /// Initialize disk cache
  Future<void> init() async {
    _box = await Hive.openBox<String>(_boxName);
  }

  /// Get value from disk cache
  Future<T?> get<T>(
    String key,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    await _ensureInitialized();

    final jsonString = _box!.get(key);
    if (jsonString == null) return null;

    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      final entry = CacheEntry.fromJson(json, fromJson as Function(dynamic p1));

      if (entry.isExpired) {
        await remove(key);
        return null;
      }

      return entry.value;
    } catch (e) {
      // Invalid cache entry, remove it
      await remove(key);
      return null;
    }
  }

  /// Put value in disk cache
  Future<void> put<T>(
    String key,
    T value,
    Map<String, dynamic> Function(T) toJson, {
    Duration ttl = const Duration(hours: 24),
  }) async {
    await _ensureInitialized();

    final expiresAt = DateTime.now().add(ttl);
    final entry = CacheEntry(value, expiresAt);

    final json = {
      'value': toJson(value),
      'expiresAt': expiresAt.toIso8601String(),
    };

    await _box!.put(key, jsonEncode(json));
  }

  /// Remove value from disk cache
  Future<void> remove(String key) async {
    await _ensureInitialized();
    await _box!.delete(key);
  }

  /// Clear all disk cache
  Future<void> clear() async {
    await _ensureInitialized();
    await _box!.clear();
  }

  /// Check if key exists
  Future<bool> has(String key) async {
    await _ensureInitialized();
    return _box!.containsKey(key);
  }

  Future<void> _ensureInitialized() async {
    _box ??= await Hive.openBox<String>(_boxName);
  }

  /// Get cache statistics
  Future<Map<String, dynamic>> get stats async {
    await _ensureInitialized();
    return {
      'entries': _box!.length,
      'keys': _box!.keys.toList(),
    };
  }
}

/// Smart cache manager combining memory and disk cache
class CacheManager {
  final MemoryCache<dynamic> _memoryCache;
  final DiskCache _diskCache;

  CacheManager({
    int memoryCacheSize = 100,
  })  : _memoryCache = MemoryCache(maxSize: memoryCacheSize),
        _diskCache = DiskCache();

  /// Initialize cache manager
  Future<void> init() async {
    await _diskCache.init();
  }

  /// Get data with smart caching strategy
  Future<T?> get<T>({
    required String key,
    required T Function(Map<String, dynamic>) fromJson,
    CacheStrategy strategy = CacheStrategy.cacheFirst,
  }) async {
    switch (strategy) {
      case CacheStrategy.cacheFirst:
        return await _cacheFirstGet(key, fromJson);

      case CacheStrategy.cacheOnly:
        return await _cacheOnlyGet(key, fromJson);

      case CacheStrategy.networkOnly:
        return null; // Let caller fetch from network

      case CacheStrategy.networkFirst:
        return null; // Let caller decide
    }
  }

  /// Put data in cache (both memory and disk)
  Future<void> put<T>({
    required String key,
    required T value,
    required Map<String, dynamic> Function(T) toJson,
    Duration memoryTtl = const Duration(minutes: 5),
    Duration diskTtl = const Duration(hours: 24),
  }) async {
    // Store in memory cache
    _memoryCache.put(key, value, ttl: memoryTtl);

    // Store in disk cache
    await _diskCache.put(key, value, toJson, ttl: diskTtl);
  }

  /// Remove from all caches
  Future<void> remove(String key) async {
    _memoryCache.remove(key);
    await _diskCache.remove(key);
  }

  /// Clear all caches
  Future<void> clear() async {
    _memoryCache.clear();
    await _diskCache.clear();
  }

  /// Cache-first strategy: Memory → Disk → Network
  Future<T?> _cacheFirstGet<T>(
    String key,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    // Try memory cache first
    final memoryValue = _memoryCache.get(key) as T?;
    if (memoryValue != null) {
      return memoryValue;
    }

    // Try disk cache
    final diskValue = await _diskCache.get(key, fromJson);
    if (diskValue != null) {
      // Populate memory cache
      _memoryCache.put(key, diskValue);
      return diskValue;
    }

    // Not in cache, caller should fetch from network
    return null;
  }

  /// Cache-only strategy
  Future<T?> _cacheOnlyGet<T>(
    String key,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    return await _cacheFirstGet(key, fromJson);
  }

  /// Get cache statistics
  Future<Map<String, dynamic>> get stats async {
    return {
      'memory': _memoryCache.stats,
      'disk': await _diskCache.stats,
    };
  }
}
