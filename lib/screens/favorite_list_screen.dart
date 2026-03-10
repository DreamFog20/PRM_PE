import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import 'item_detail_screen.dart';

class FavoriteListScreen extends StatefulWidget {
  @override
  _FavoriteListScreenState createState() => _FavoriteListScreenState();
}

class _FavoriteListScreenState extends State<FavoriteListScreen> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<AppProvider>(context, listen: false);
    _searchController.text = provider.searchQuery;
  }

  void _onSearchChanged(String query) {
    Provider.of<AppProvider>(context, listen: false).setSearchQuery(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm đã lưu...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.white70),
                ),
                style: TextStyle(color: Colors.white, fontSize: 18),
                onChanged: _onSearchChanged,
              )
            : Text('Đã Lưu (Screen 4)'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  _onSearchChanged('');
                }
              });
            },
          )
        ],
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          final items = provider.favoriteItems;

          if (items.isEmpty) {
            return Center(child: Text('Không có mục yêu thích nào.', style: TextStyle(fontSize: 16)));
          }

          return ListView.builder(
            padding: EdgeInsets.all(8),
            itemCount: items.length,
            itemBuilder: (ctx, index) {
              final item = items[index];
              return Card(
                elevation: 2,
                margin: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                color: Colors.amber[100],
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    child: Text(
                      item.name.substring(0, 1).toUpperCase(),
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(item.name, style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(item.description, maxLines: 1, overflow: TextOverflow.ellipsis),
                  trailing: IconButton(
                    icon: Icon(Icons.star, color: Colors.amber, size: 30),
                    onPressed: () {
                      provider.toggleFavorite(item.id);
                    },
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => ItemDetailScreen(item: item),
                    ));
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
