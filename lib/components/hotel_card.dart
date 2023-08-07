class HotelCard {
  final String imagePath;
  final String restaurantName;
  final bool isNonVeg;

  HotelCard(
      {required this.imagePath,
        required this.restaurantName,
        required this.isNonVeg});
}

List<HotelCard> hotelList = [
  HotelCard(
      imagePath: "images/f6.jpg",
      restaurantName: "Surya family restaurant",
      isNonVeg: false),
  HotelCard(
      imagePath: "images/f2.jpg",
      restaurantName: "Matoshri Restaurant",
      isNonVeg: true),
  HotelCard(
      imagePath: "images/f3.jpg",
      restaurantName: "Hotel Martand",
      isNonVeg: false),
  HotelCard(
      imagePath: "images/f4.jpg",
      restaurantName: "Couple's Corner",
      isNonVeg: true),
  HotelCard(
      imagePath: "images/f3.jpg",
      restaurantName: "friends Forever",
      isNonVeg: false),
  HotelCard(
      imagePath: "images/f5.jpg",
      restaurantName: "Shivneri Dhaba",
      isNonVeg: true),
  HotelCard(
      imagePath: "images/f1.jpg",
      restaurantName: "Hotel Maratha",
      isNonVeg: false),
];