class Menu {
  String id_item_menu;
  String nombre_item;

  Menu({this.id_item_menu, this.nombre_item});

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      id_item_menu: (json['id_item_menu']) as String,
      nombre_item: json['nombre_item'] as String,
    );
  }
}
