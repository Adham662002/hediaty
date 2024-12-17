class Gift {
  final String name;
  final String category;
  final String status;

  Gift(this.name, this.category, this.status);

  // Dummy data
  static List<Gift> dummyGifts = [
    Gift('Apple Watch', 'Electronics', 'Available'),
    Gift('Book', 'Books', 'Available'),
    Gift('Bluetooth Speaker', 'Appliances', 'Available'),
    Gift('Desk Organizer Set', 'Appliances', 'Available'),
    Gift('Laptop', 'Electronics', 'Available'),
    Gift('Smartphone', 'Electronics', 'Available'),
    Gift('Silk Scarf', 'Clothing', 'Available'),
    Gift('Television', 'Electronics', 'Available'),
  ];
}
