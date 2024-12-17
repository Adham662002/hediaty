import 'package:firebase/models/event_model.dart';

class EventController {
  // Retrieve all events from Event model
  static List<Event> getAllEvents() {
    return Event.dummyEvents;
  }
}
