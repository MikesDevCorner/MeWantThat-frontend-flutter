class ShoppingList {

  final int id;
  final String listenname;
  final String created_at;
  final String updated_at;

  ShoppingList({this.id, this.listenname, this.created_at, this.updated_at});

  factory ShoppingList.fromJson(Map<String, dynamic> json) {
    return ShoppingList(
        id: json['id'],
        listenname: json['listenname'],
        created_at: json['created_at'],
        updated_at: json['updated_at']
    );
  }
}