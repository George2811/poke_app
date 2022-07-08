
class Pokemon {
  int id;
  String name;

  Pokemon(this.id, this.name);

  Map<String, dynamic> toMap() {
    return{
      'id': (id == 0)? null : id,
      'name': name,
    };
  }

}
