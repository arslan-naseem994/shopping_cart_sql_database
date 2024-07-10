import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart/models/cart_model.dart';
import 'package:shopping_cart/provider/cart_provider.dart';
import 'package:shopping_cart/utils/db_helper.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  DBHelper? dbHelper = DBHelper();

  get badges => null;

  @override
  Widget build(BuildContext context) {
    debugPrint('safeArea');

    final cart = Provider.of<CartProvider>(
      context,
    );
    return SafeArea(
      child: Scaffold(
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
            'My Products',
            style: TextStyle(color: Colors.white),
          ),
          actions: const [
            // badges.Badge(
            //   badgeAnimation: badges.BadgeAnimation.slide(
            //       animationDuration: const Duration(seconds: 2)),
            //   badgeStyle: badges.BadgeStyle(badgeColor: Colors.yellow),
            //   badgeContent:
            //       Consumer<CartProvider>(builder: (context, value, child) {
            //     return Text(value.getCounter().toString());
            //   }),
            //   child: const Icon(
            //     Icons.shopping_bag_outlined,
            //     color: Colors.white,
            //   ),
            // ),

            SizedBox(
              width: 20,
            ),
          ],
        ),
        body: Column(
          children: [
            FutureBuilder(
                future: cart.getData(),
                builder: ((context, AsyncSnapshot<List<Cart>> snapshot) {
                  if (snapshot.hasData) {
                    return Expanded(
                        child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: ((context, index) {
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                elevation: 10,
                                margin: const EdgeInsets.all(10),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Image(
                                                height: 80,
                                                width: 80,
                                                image: NetworkImage(snapshot
                                                    .data![index].image
                                                    .toString())),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        snapshot.data![index]
                                                            .productName
                                                            .toString(),
                                                        style: const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          dbHelper!.delete(
                                                              snapshot
                                                                  .data![index]
                                                                  .id!);
                                                          cart.removerCounter();
                                                          cart.removeTotalPrice(
                                                              double.parse(snapshot
                                                                  .data![index]
                                                                  .productPrice
                                                                  .toString()));
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .removeCurrentSnackBar();
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            const SnackBar(
                                                              content: Text(
                                                                  'Item deleted!'),
                                                              duration: Duration(
                                                                  milliseconds:
                                                                      500),
                                                            ),
                                                          );
                                                        },
                                                        child: Center(
                                                          child: ShaderMask(
                                                            blendMode: BlendMode
                                                                .srcATop,
                                                            shaderCallback:
                                                                (Rect bounds) {
                                                              return const LinearGradient(
                                                                colors: [
                                                                  Color(
                                                                      0xFFFF512F),
                                                                  Color(
                                                                      0xFFDD2476)
                                                                ],
                                                                begin: Alignment
                                                                    .topLeft,
                                                                end: Alignment
                                                                    .bottomRight,
                                                              ).createShader(
                                                                  bounds);
                                                            },
                                                            child: const Icon(
                                                              Icons.delete,
                                                              size: 30,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  Text(
                                                    '${snapshot.data![index].unitTag.toString()} \$${snapshot.data![index].productPrice.toString()}',
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Container(
                                                      height: 25,
                                                      width: 100,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          color: Colors
                                                              .transparent),
                                                      child: Center(
                                                          child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              int quantity =
                                                                  snapshot
                                                                      .data![
                                                                          index]
                                                                      .quantity!;
                                                              int price = snapshot
                                                                  .data![index]
                                                                  .initialPrice!;
                                                              quantity--;
                                                              int? newPrice =
                                                                  price *
                                                                      quantity;
                                                              if (quantity >
                                                                  0) {
                                                                dbHelper!
                                                                    .updateQuantity(Cart(
                                                                        id: snapshot
                                                                            .data![
                                                                                index]
                                                                            .id,
                                                                        productId: snapshot
                                                                            .data![
                                                                                index]
                                                                            .id
                                                                            .toString(),
                                                                        productName: snapshot
                                                                            .data![
                                                                                index]
                                                                            .productName,
                                                                        initialPrice: snapshot
                                                                            .data![
                                                                                index]
                                                                            .initialPrice,
                                                                        productPrice:
                                                                            newPrice,
                                                                        quantity:
                                                                            quantity,
                                                                        unitTag: snapshot
                                                                            .data![
                                                                                index]
                                                                            .unitTag,
                                                                        image: snapshot
                                                                            .data![
                                                                                index]
                                                                            .image))
                                                                    .then(
                                                                        (value) {
                                                                  newPrice = 0;
                                                                  quantity = 0;
                                                                  cart.removeTotalPrice(double.parse(snapshot
                                                                      .data![
                                                                          index]
                                                                      .initialPrice!
                                                                      .toString()));
                                                                }).onError((error,
                                                                        stackTrace) {
                                                                  debugPrint(
                                                                      '$error');
                                                                });
                                                              }
                                                            },
                                                            child: const Icon(
                                                              Icons
                                                                  .remove_circle_outline,
                                                              color:
                                                                  Colors.black,
                                                              size: 26,
                                                            ),
                                                          ),
                                                          Text(snapshot
                                                              .data![index]
                                                              .quantity
                                                              .toString()),
                                                          InkWell(
                                                            onTap: () {
                                                              int quantity =
                                                                  snapshot
                                                                      .data![
                                                                          index]
                                                                      .quantity!;
                                                              int price = snapshot
                                                                  .data![index]
                                                                  .initialPrice!;
                                                              quantity++;
                                                              int? newPrice =
                                                                  price *
                                                                      quantity;
                                                              dbHelper!
                                                                  .updateQuantity(Cart(
                                                                      id: snapshot
                                                                          .data![
                                                                              index]
                                                                          .id,
                                                                      productId: snapshot
                                                                          .data![
                                                                              index]
                                                                          .id
                                                                          .toString(),
                                                                      productName: snapshot
                                                                          .data![
                                                                              index]
                                                                          .productName,
                                                                      initialPrice: snapshot
                                                                          .data![
                                                                              index]
                                                                          .initialPrice,
                                                                      productPrice:
                                                                          newPrice,
                                                                      quantity:
                                                                          quantity,
                                                                      unitTag: snapshot
                                                                          .data![
                                                                              index]
                                                                          .unitTag,
                                                                      image: snapshot
                                                                          .data![
                                                                              index]
                                                                          .image))
                                                                  .then(
                                                                      (value) {
                                                                newPrice = 0;
                                                                quantity = 0;
                                                                cart.addTotalPrice(
                                                                    double.parse(snapshot
                                                                        .data![
                                                                            index]
                                                                        .initialPrice!
                                                                        .toString()));
                                                              }).onError((error,
                                                                      stackTrace) {
                                                                debugPrint(
                                                                    '$error');
                                                              });
                                                            },
                                                            child: const Icon(
                                                              Icons
                                                                  .add_circle_outline,
                                                              color:
                                                                  Colors.black,
                                                              size: 26,
                                                            ),
                                                          ),
                                                        ],
                                                      )),
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
                                  // Add your child widget here
                                ),
                              );
                            })));
                  } else {
                    return const Text('Error');
                  }
                })),
            Consumer<CartProvider>(builder: ((context, value, child) {
              return Visibility(
                visible: value.totalPrice == 0.00 ? false : true,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Container(
                        height: 120,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF009245),
                              Color(0xffFCEE21),
                            ],
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ReuseableWidget(
                                title: 'Subtotal ',
                                value:
                                    '\$${value.getTotalPrice().toStringAsFixed(1)}'),
                            const ReuseableWidget(
                                title: 'Discounts ', value: '10%'),
                            ReuseableWidget(
                                title: 'Total ',
                                value:
                                    '${value.getTotalPrice() - (10 / 100 * value.getTotalPrice())}'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            })),
          ],
        ),
      ),
    );
  }
}

class ReuseableWidget extends StatelessWidget {
  final String title, value;
  const ReuseableWidget({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          Text(value.toString(), style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
