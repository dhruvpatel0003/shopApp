import 'dart:convert';

import 'package:flutter/cupertino.dart';

import './cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {required this.id,
      required this.amount,
      required this.products,
      required this.dateTime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String authToken;
  final String? userId;

  Orders(this.authToken,this.userId,this._orders);


  List<OrderItem> get orders {
    // print("inside the ordersssssss"+orders.length.toString());
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url = Uri.parse(
        'https://food-area-27b5e-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken');
    final response = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    print(json.decode(response.body).toString());
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    // if (extractedData == null) {
    //   return;
    // }
    extractedData.forEach((orderId, orderData) {
      // print('inside the fetchandsetorders'+orderId);
      // print('inside the fetchandsetorders'+orderData['amount'].toString());
      print(orderData['products'] as List<dynamic>);
      loadedOrders.add(OrderItem(
          id: orderId,
          amount: orderData['amount'],
          // products: orderData.map((cp)=>cp.toJson()).toList(), //////////////////////////////////////
          dateTime: DateTime.now(),//////////////////////////bug///////////////////////////////////////////////////////////////////////////////////

          products: (orderData['products'] as List<dynamic>)
              .map((item) => CartItem(
                  id: item['id'],
                  title: item['title'],
                  price: item['price'],
                  quantity: item['quantity']))
              .toList(),

          ));
    });
    // print(json.decode(json.decode(response.body)));
    _orders = loadedOrders.reversed.toList();
    notifyListeners();

    print('After inside the fetchandsetorders');
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = Uri.parse(
        'https://food-area-27b5e-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken');
    // print("inside the orders..." + cartProducts.toString());
    final timestamp = DateTime.now();
    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'dateTime': timestamp.toIso8601String(), //easly recreatable
          // 'products' : cartProducts.map((cp) => {
          //   'id':cp.id,
          //   'title':cp.title,
          //   'quantity': cp.quantity,
          //   'price' : cp.price
          // })
          'products': cartProducts.map((cp) => cp.toJson()).toList()
        }));
    _orders.insert(
        0,
        OrderItem(
            id: json.decode(response.body)['name'],
            amount: total,
            products: cartProducts,
            dateTime: DateTime.now()));
    notifyListeners();
  }
}
