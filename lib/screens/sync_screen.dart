import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import 'item_list_screen.dart';

class SyncScreen extends StatefulWidget {
  @override
  _SyncScreenState createState() => _SyncScreenState();
}

class _SyncScreenState extends State<SyncScreen> {
  void _showMessage(String title, String message, {bool isError = true}) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title, style: TextStyle(color: isError ? Colors.red : Colors.green)),
        content: Text(message),
        actions: [
          TextButton(
            child: Text('Đóng'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  void _onOnlineSelected() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Center(child: CircularProgressIndicator()),
    );

    final provider = Provider.of<AppProvider>(context, listen: false);
    await provider.fetchOnlineData();
    
    if (Navigator.canPop(context)) Navigator.of(context).pop(); // close dialog

    if (provider.errorMessage != null) {
      _showMessage('Lỗi cập nhật', provider.errorMessage!);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đồng bộ thành công!'), backgroundColor: Colors.green),
      );
      Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => ItemListScreen()));
    }
  }

  void _onOfflineSelected() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Center(child: CircularProgressIndicator()),
    );

    final provider = Provider.of<AppProvider>(context, listen: false);
    bool hasData = await provider.checkLocalDataExists();

    if (hasData) {
      await provider.loadLocalData();
      if (Navigator.canPop(context)) Navigator.of(context).pop(); // close dialog
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tải dữ liệu offline thành công!'), backgroundColor: Colors.blue),
      );
      Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => ItemListScreen()));
    } else {
      if (Navigator.canPop(context)) Navigator.of(context).pop(); // close dialog
      _showMessage('Thông báo', 'Dữ liệu không tồn tại! Vui lòng thực hiện Trạng thái Online để lấy cập nhật thông tin.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Khởi Động - Screen 1'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blueAccent,
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                   Icon(
                    Icons.cloud_sync,
                    size: 100,
                    color: Colors.blueAccent,
                  ),
                  SizedBox(height: 48),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: Icon(Icons.cloud_download, color: Colors.white),
                    label: Text('Trạng Thái Online (Cập Nhật)', style: TextStyle(fontSize: 18, color: Colors.white)),
                    onPressed: _onOnlineSelected,
                  ),
                  SizedBox(height: 24),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: Colors.blueAccent, width: 2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: Icon(Icons.offline_pin, color: Colors.blueAccent),
                    label: Text('Trạng Thái Offline', style: TextStyle(fontSize: 18, color: Colors.blueAccent)),
                    onPressed: _onOfflineSelected,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
