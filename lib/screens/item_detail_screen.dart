import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/item_model.dart';
import '../providers/app_provider.dart';

class ItemDetailScreen extends StatelessWidget {
  final Item item;

  ItemDetailScreen({required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Chi Tiết (Screen 3)'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          // Find updated item from provider to reflect changes
          final currentItem = provider.items.firstWhere(
            (element) => element.id == item.id,
            orElse: () => item,
          );

          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.blueAccent,
                  child: Text(
                    currentItem.name.substring(0, 1).toUpperCase(),
                    style: TextStyle(fontSize: 48, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 24),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tên Item:', style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                        SizedBox(height: 4),
                        Text(currentItem.name, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        SizedBox(height: 16),
                        Text('Mô tả chi tiết:', style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                        SizedBox(height: 4),
                        Text(currentItem.description, style: TextStyle(fontSize: 18)),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 32),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: currentItem.isFavorite ? Colors.grey[300] : Colors.amber,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: Icon(
                    currentItem.isFavorite ? Icons.star_border : Icons.star,
                    color: currentItem.isFavorite ? Colors.black54 : Colors.white,
                  ),
                  label: Text(
                    currentItem.isFavorite ? 'Bỏ Yêu Thích' : 'Thêm Vào Yêu Thích',
                    style: TextStyle(
                      fontSize: 18,
                      color: currentItem.isFavorite ? Colors.black87 : Colors.white,
                    ),
                  ),
                  onPressed: () {
                    provider.toggleFavorite(currentItem.id);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
