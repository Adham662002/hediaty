class PledgedGift {
  final String giftName;
  final String friendName;
  final String dueDate;

  PledgedGift(this.giftName, this.friendName, this.dueDate);

  // Dummy data
  static List<PledgedGift> dummyPledgedGifts = [
    PledgedGift('Apple Watch', 'Basem Ali', '9-9-2024'),
    PledgedGift('Laptop', 'Basma Hossam', '11-9-2024'),
    PledgedGift('Television', 'Eman Hosni', '25-9-2024'),
  ];
}
