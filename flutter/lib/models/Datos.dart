class Datos {
  final int id;
  final String title;
  final String body;

  Datos({
    required this.id,
    required this.title,
    required this.body,
  });

  factory Datos.fromJson(Map<String, dynamic> json) => Datos(
      id: json['id'],
      title: json['title'],
      body: json['body']
  );
}

