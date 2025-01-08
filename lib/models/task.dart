class Task {
  int? id;
  String? title;
  bool isDone;

  Task({
    this.id,
    required this.title,
    this.isDone = false,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      isDone: json['isDone'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isDone': isDone ? 1 : 0,
    };
  }

  void toggle() {
    isDone = !isDone;
  }
}
