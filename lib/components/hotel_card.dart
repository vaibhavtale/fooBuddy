

class HotelCard{

  final String imagePath;
  final String restaurantName;
  final bool nonVeg;

  HotelCard({required this.imagePath, required this.restaurantName, required this.nonVeg});
}


List<HotelCard> hotelList = [

  HotelCard(imagePath: "images/f6.jpg", restaurantName: "Hotel Surya family restaurant", nonVeg: false),
  HotelCard(imagePath: "images/f2.jpg", restaurantName: "Couple Corner", nonVeg: true),
  HotelCard(imagePath: "images/f3.jpg", restaurantName: "Hotel Martand", nonVeg: false),
  HotelCard(imagePath: "images/f4.jpg", restaurantName: "Couple Corner", nonVeg: true),
  HotelCard(imagePath: "images/f3.jpg", restaurantName: "Hotel Martand", nonVeg: false),
  HotelCard(imagePath: "images/f5.jpg", restaurantName: "Couple Corner", nonVeg: true),
  HotelCard(imagePath: "images/f1.jpg", restaurantName: "Hotel Martand", nonVeg: false),
];