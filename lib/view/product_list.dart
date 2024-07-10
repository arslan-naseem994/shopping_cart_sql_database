import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart/models/cart_model.dart';
import 'package:shopping_cart/provider/cart_provider.dart';
import 'package:shopping_cart/utils/db_helper.dart';
import 'package:shopping_cart/view/cart_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  DBHelper? dbHelper = DBHelper();

  List<String> productName = [
    'Mango',
    'Orange',
    'Grapes',
    'Banana',
    'Chery',
    'Peach',
    'Mixed Fruit Basket',
  ];
  List<String> productUnit = [
    'KG',
    'Dozen',
    'KG',
    'Dozen',
    'KG',
    'KG',
    'KG',
  ];
  List<int> productPrice = [10, 20, 30, 40, 50, 60, 70];
  List<String> productImage = [
    'https://image.shutterstock.com/image-photo/mango-isolated-on-white-background-600w-610892249.jpg',
    'https://image.shutterstock.com/image-photo/orange-fruit-slices-leaves-isolated-600w-1386912362.jpg',
    'https://image.shutterstock.com/image-photo/green-grape-leaves-isolated-on-600w-533487490.jpg',
    'https://media.istockphoto.com/id/636739634/photo/banana.jpg?s=1024x1024&w=is&k=20&c=sU3thHGc_XbWvRlYi1x5YlzQdWYKDEYXgUrmv2T5HfU=',
    'https://media.istockphoto.com/id/533381303/photo/cherry-with-leaves-isolated-on-white-background.jpg?s=1024x1024&w=is&k=20&c=91Fl8anu-m-dHoUfmbzay0PWbPEw1A4C-FMfu6WzrvM=',
    'https://media.istockphoto.com/id/1151868959/photo/single-whole-peach-fruit-with-leaf-and-slice-isolated-on-white.jpg?s=1024x1024&w=is&k=20&c=zLb--kmGvSTUkjgSwVXForXx1C3WRSjGN77rXm_y6XM=',
    'https://media.istockphoto.com/id/810147810/photo/fruit-bowl-isolated.jpg?s=1024x1024&w=is&k=20&c=PcFEu1TEtUFz8Bt55oe4T0U_6ug7CR2kY99FJfQgrTw=',
  ];

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF02AABD),
                Color(0xFF00CDAC),
              ],
            ),
          ),
        ),
        centerTitle: true,
        title: const Text(
          'Products',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => const CartScreen())));
            },
            child: badges.Badge(
              badgeAnimation: const badges.BadgeAnimation.slide(
                  animationDuration: Duration(seconds: 2)),
              badgeStyle: const badges.BadgeStyle(badgeColor: Colors.yellow),
              badgeContent:
                  Consumer<CartProvider>(builder: (context, value, child) {
                return Text(value.getCounter().toString());
              }),
              child: const Icon(
                Icons.shopping_bag_outlined,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                  itemCount: productName.length,
                  itemBuilder: ((context, index) {
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 10,
                      margin: const EdgeInsets.all(10),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(17),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF009245),
                              Color(0xFFFFEE21),
                            ],
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Image(
                                      height: 80,
                                      width: 80,
                                      image: NetworkImage(
                                          productImage[index].toString())),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          productName[index].toString(),
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          '${productUnit[index]} \$${productPrice[index]}',
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: InkWell(
                                            onTap: () {
                                              // First, get data from the cart asynchronously
                                              cart.getData().then((cartList) {
                                                bool itemExists = cartList.any(
                                                    (cart) =>
                                                        cart.productId ==
                                                        index.toString());

                                                if (itemExists) {
                                                  // If the item already exists in the cart, show a SnackBar and return
                                                  ScaffoldMessenger.of(context)
                                                      .removeCurrentSnackBar();
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                          'Item is already added to the cart!'),
                                                      duration: Duration(
                                                          milliseconds: 1500),
                                                    ),
                                                  );
                                                  return;
                                                }

                                                // If the item does not exist, proceed to insert it into the cart
                                                dbHelper!
                                                    .insert(Cart(
                                                  id: index,
                                                  productId: index.toString(),
                                                  productName:
                                                      productName[index]
                                                          .toString(),
                                                  initialPrice:
                                                      productPrice[index],
                                                  productPrice:
                                                      productPrice[index],
                                                  quantity: 1,
                                                  unitTag: productUnit[index]
                                                      .toString(),
                                                  image: productImage[index]
                                                      .toString(),
                                                ))
                                                    .then((value) {
                                                  // Show "Item added" SnackBar
                                                  ScaffoldMessenger.of(context)
                                                      .removeCurrentSnackBar();
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content:
                                                          Text('Item added!'),
                                                      duration: Duration(
                                                          milliseconds: 500),
                                                    ),
                                                  );

                                                  cart.addTotalPrice(
                                                      double.parse(
                                                          productPrice[index]
                                                              .toString()));
                                                  cart.addCounter();
                                                }).catchError((error) {
                                                  // Show error SnackBar if insertion fails
                                                  ScaffoldMessenger.of(context)
                                                      .removeCurrentSnackBar();
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                          'Failed to add item to cart!'),
                                                      duration: Duration(
                                                          milliseconds: 1500),
                                                    ),
                                                  );
                                                });
                                              });
                                            },
                                            child: Container(
                                              height: 25,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color: Colors.green),
                                              child: const Center(
                                                child: Text(
                                                  'Add to cart',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }))),
        ],
      ),
    );
  }
}
