class Contact {
  String? key;
  String name;
  String phone;

  Contact({this.key, required this.name, required this.phone});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
    };
  }

  static Contact fromMap(Map<dynamic, dynamic> map, String key) {
    return Contact(
      key: key,
      name: map['name'],
      phone: map['phone'],
    );
  }
}
