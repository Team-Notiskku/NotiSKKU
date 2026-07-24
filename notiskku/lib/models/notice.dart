class Notice {
  final String id;
  final String category;
  final String title;
  final String date;
  final String uploader;
  final String views;
  final String link;

  Notice({
    required this.id,
    required this.category,
    required this.title,
    required this.date,
    required this.uploader,
    required this.views,
    required this.link,
  });

  Map<String, String> toJson() => {
    'id': id,
    'category': category,
    'title': title,
    'date': date,
    'uploader': uploader,
    'views': views,
    'link': link,
  };

  factory Notice.fromJson(Map<String, dynamic> json) => Notice(
    id: json['id'] ?? '',
    category: json['category'] ?? '',
    title: json['title'] ?? '',
    date: json['date'] ?? '',
    uploader: json['uploader'] ?? '',
    views: json['views'] ?? '',
    link: json['link'] ?? '',
  );
}
