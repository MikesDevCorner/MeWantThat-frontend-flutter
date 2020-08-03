class ShoppingEntry {

  final int id;
  final String postenname;
  final int anzahl;
  final int einkaufsliste_id;
  final String created_at;
  final String updated_at;


  ShoppingEntry({this.id, this.postenname, this.anzahl, this.einkaufsliste_id,
    this.created_at, this.updated_at});

  factory ShoppingEntry.fromJson(Map<String, dynamic> json) {
    return ShoppingEntry(
        id: json['id'],
        postenname: json['postenname'],
        anzahl: json['anzahl'],
        einkaufsliste_id: json['einkaufsliste_id'],
        created_at: json['created_at'],
        updated_at: json['updated_at']
    );
  }
}