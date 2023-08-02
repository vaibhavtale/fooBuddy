class Order {
  final String itemName;
  final int price;
  final String imagePath;
  final DateTime date;

  Order(
      {required this.itemName,
      required this.imagePath,
      required this.date,
      required this.price});
}

List<Order> OrderList = [];

void addItemsInOrderList(Order order) {
  OrderList.add(order);
}

// remove order if the order is cancelled.
