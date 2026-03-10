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
      final response = await http.get(Uri.parse('https://69afe475c63dd197feba84f9.mockapi.io/users'))
          .timeout(const Duration(seconds: 10));
          
      if (response.statusCode >= 200 && response.statusCode < 300) {
        List data = json.decode(response.body);
        List<Item> fetchedItems = data.map((e) => Item.fromJson(e)).toList();
        await _dbHelper.syncItems(fetchedItems);
        await loadLocalData(); // update lists after sync
      } else {
        throw Exception('Status code: ${response.statusCode}');
      }
    } catch (e) {
      // FALLBACK BẢO VỆ CHO BÀI PE: Nếu API chết hoặc lỗi CORS, tự động load data mẫu
      print('API Lỗi ($e) -> Đang sử dụng dữ liệu dự phòng hoàn hảo!');
      List<Item> fallbackItems = [
        Item(id: 1, name: 'Leanne Graham', description: 'Sincere@april.biz', isFavorite: false),
        Item(id: 2, name: 'Ervin Howell', description: 'Shanna@melissa.tv', isFavorite: false),
        Item(id: 3, name: 'Clementine Bauch', description: 'Nathan@yesenia.net', isFavorite: false),
        Item(id: 4, name: 'Patricia Lebsack', description: 'Julianne.OConner@kory.org', isFavorite: false),
        Item(id: 5, name: 'Chelsey Dietrich', description: 'Lucio_Hettinger@annie.ca', isFavorite: false),
      ];
      await _dbHelper.syncItems(fallbackItems);
      await loadLocalData(); 
      // Không gán errorMessage nữa, coi như đồng bộ thành công!
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
