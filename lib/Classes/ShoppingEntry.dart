class ShoppingEntry {

  final int id;
  final String entryname;
  final int amount;
  final int shopping_list_id;
  final String created_at;
  final String updated_at;


  ShoppingEntry({this.id, this.entryname, this.amount, this.shopping_list_id,
    this.created_at, this.updated_at});

  factory ShoppingEntry.fromJson(Map<String, dynamic> json) {
    return ShoppingEntry(
        id: json['id'],
        entryname: json['entryname'],
        amount: json['amount'],
        shopping_list_id: json['shopping_list_id'],
        created_at: json['created_at'],
        updated_at: json['updated_at']
    );
  }
}