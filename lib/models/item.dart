class Item {
  int id;
  String title;
  String subtitle;
  bool done;

  Item({this.id, this.title, this.subtitle, this.done});

  Item.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    subtitle = json['subtitle'];
    done = json['done'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['subtitle'] = this.subtitle;
    data['done'] = this.done;
    return data;
  }
}
