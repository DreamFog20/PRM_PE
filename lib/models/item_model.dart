class Item {
  int id;
  String name;
  String description;
  bool isFavorite;

  Item({
    required this.id,
    required this.name,
    required this.description,
    this.isFavorite = false,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? 'Không có tên',
      description: json['email'] ?? 'Không có thông tin chi tiết',
      isFavorite: false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'isFavorite': isFavorite ? 1 : 0,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      isFavorite: map['isFavorite'] == 1,
    );
  }
}
