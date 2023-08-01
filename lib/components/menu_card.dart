

class MenuCard{

  final String imagePath;
  final String foodName;
  final bool nonVeg;
  final int price;

  MenuCard({required this.imagePath, required this.foodName, required this.nonVeg, required this.price});
}

List<MenuCard> menuList = [

  MenuCard(imagePath: "images/paneer1.jpg", foodName: "paneer masala", nonVeg: false, price: 150),
  MenuCard(imagePath: "images/ice_cream1.jpg", foodName: "ice_cream vanila", nonVeg: true, price: 150),
  MenuCard(imagePath: "images/roll1.jpg", foodName: "chicken roll", nonVeg: false, price: 150),
  MenuCard(imagePath: "images/biryani1.jpg", foodName: "biryani", nonVeg: true, price: 150),
  MenuCard(imagePath: "images/dumpling1.jpg", foodName: "dumpling veg", nonVeg: false, price: 150),
  MenuCard(imagePath: "images/pizza1.jpg", foodName: "pizza slicy", nonVeg: true, price: 150),
  MenuCard(imagePath: "images/dumpling2.jpg", foodName: "dumpling non veg", nonVeg: false, price: 150),
  MenuCard(imagePath: "images/donat1.jpg", foodName: "donat choco-cream", nonVeg: false, price: 150),
  MenuCard(imagePath: "images/ice_cream2.jpg", foodName: "ice_cream choco", nonVeg: true, price: 150),
  MenuCard(imagePath: "images/roll2.jpg", foodName: "chicken roll spicy", nonVeg: false, price: 150),
  MenuCard(imagePath: "images/biryani2.jpg", foodName: "chicken biryani", nonVeg: true, price: 150),
  MenuCard(imagePath: "images/dumpling3.jpg", foodName: "dumpling veg", nonVeg: false, price: 150),
  MenuCard(imagePath: "images/chicken1.jpg", foodName: "chicken curry", nonVeg: true, price: 150),
  MenuCard(imagePath: "images/dumpling4.jpg", foodName: "dumpling", nonVeg: false, price: 150),
];

List<MenuCard> userCartList = [];
List<MenuCard> savedItems = [];

//for full list
List<MenuCard> getMenuList() {
  return menuList;
}

//for adding items to Cart
void addItemToCart(MenuCard menuCard){

  userCartList.add(menuCard);
}

//for saving Items

void saveItemToList(MenuCard menuCard){

  savedItems.add(menuCard);
}

// for Cart
void removeFromCart(MenuCard menuCard){

  userCartList.remove(menuCard);
}

//for saved list

void removeFromSavedList(MenuCard menuCard){

  savedItems.remove(menuCard);
}
