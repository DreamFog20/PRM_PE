import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/item_model.dart';
import '../database/db_helper.dart';

class AppProvider with ChangeNotifier {
  List<Item> _items = [];
  List<Item> get items => _items;
  
  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  final DBHelper _dbHelper = DBHelper();

  List<Item> get filteredItems {
    if (_searchQuery.isEmpty) return _items;
    return _items.where((item) => 
      item.name.toLowerCase().contains(_searchQuery.toLowerCase()) || 
      item.description.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }

  List<Item> get favoriteItems {
    return filteredItems.where((item) => item.isFavorite).toList();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> fetchOnlineData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));
      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        List<Item> fetchedItems = data.map((e) => Item.fromJson(e)).toList();
        
        await _dbHelper.syncItems(fetchedItems);
        await loadLocalData(); // update lists after sync
      } else {
        _errorMessage = 'Tải dữ liệu thất bại: Lỗi máy chủ';
      }
    } catch (e) {
      _errorMessage = 'Tải dữ liệu thất bại: Vui lòng kiểm tra kết nối mạng của bạn.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadLocalData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _items = await _dbHelper.getItems();
      if (_items.isEmpty) {
        _errorMessage = 'Không có dữ liệu lưu trữ local. Vui lòng sử dụng trạng thái online để đồng bộ.';
      }
    } catch (e) {
      _errorMessage = 'Lỗi truy xuất dữ liệu local.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> checkLocalDataExists() async {
    int count = await _dbHelper.getCount();
    return count > 0;
  }

  Future<void> toggleFavorite(int id) async {
    final index = _items.indexWhere((item) => item.id == id);
    if (index >= 0) {
      final currentStatus = _items[index].isFavorite;
      _items[index].isFavorite = !currentStatus;
      await _dbHelper.updateItemFavorite(id, !currentStatus);
      notifyListeners();
    }
  }
}
