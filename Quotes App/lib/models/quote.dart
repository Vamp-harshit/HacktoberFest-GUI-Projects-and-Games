import 'dart:math';

class Quote {
  String? content;
  String? author;
  String? id;

  Quote({
    this.id,
    this.content,
    this.author,
  });

  factory Quote.fromJson(Map<String, dynamic> json, int? count) {
    if (count == null) {
      return Quote(
        id: json['_id'],
        content: json['content'],
        author: json['author'],
      );
    } else {
      int random = 0 + Random().nextInt(count - 0);
      return Quote(
        id: json['results'][random]['_id'],
        content: json["results"][random]["content"],
        author: json["results"][random]["author"],
      );
    }
  }

  Map<String, dynamic> toJsonForSP() => {
        'content': content,
        'author': author,
        '_id': id,
      };
}
