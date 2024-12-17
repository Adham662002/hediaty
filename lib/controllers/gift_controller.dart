import 'package:firebase/models/gift_model.dart';          // Import Gift model
import 'package:firebase/models/pledgedgift_model.dart';  // Import PledgedGift model

class GiftController {
  // Retrieve all gifts from Gift model
  static List<Gift> getAllGifts() {
    return Gift.dummyGifts;
  }

  // Retrieve all pledged gifts from PledgedGift model
  static List<PledgedGift> getAllPledgedGifts() {
    return PledgedGift.dummyPledgedGifts;
  }

  // Add a new gift
  static void addGift(Gift newGift) {
    Gift.dummyGifts.add(newGift);
  }

  // Add a new pledged gift
  static void addPledgedGift(PledgedGift newPledgedGift) {
    PledgedGift.dummyPledgedGifts.add(newPledgedGift);
  }

  // Delete a gift
  static void deleteGift(Gift gift) {
    Gift.dummyGifts.remove(gift);
  }

  // Delete a pledged gift
  static void deletePledgedGift(PledgedGift pledgedGift) {
    PledgedGift.dummyPledgedGifts.remove(pledgedGift);
  }
}
