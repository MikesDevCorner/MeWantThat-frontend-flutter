class ShoppingList {

  final int id;
  final String listname;
  final String created_at;
  final String updated_at;

  ShoppingList({this.id, this.listname, this.created_at, this.updated_at});

  factory ShoppingList.fromJson(Map<String, dynamic> json) {
    return ShoppingList(
        id: json['id'],
        listname: json['listname'],
        created_at: json['created_at'],
        updated_at: json['updated_at']
    );
  }
}