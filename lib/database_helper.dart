class Event {
  final String? id;
  final String name;
  final String description;
  final String location;
  final DateTime date;

  Event({
    this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.date,
  });

  // Convert an Event object to a Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id ?? DateTime.now().toString(),
      'name': name,
      'description': description,
      'location': location,
      'date': date.toIso8601String(),
    };
  }

  // Create an Event object from a Map
  static Event fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      location: map['location'],
      date: DateTime.parse(map['date']),
    );
  }
}
