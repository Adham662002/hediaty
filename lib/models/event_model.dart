class Event {
  final String name;
  final String category;
  final String status;

  Event(this.name, this.category, this.status);

  // Dummy data for now
  static List<Event> dummyEvents = [
    Event('Birthday Party', 'Personal', 'Upcoming'),
    Event('Wedding Ceremony', 'Social', 'Past'),
    Event('Tech Conference', 'Professional', 'Upcoming'),
    Event('Festival Celebration', 'Cultural', 'Current'),
  ];
}
