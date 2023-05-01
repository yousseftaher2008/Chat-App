import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/orders.dart' show Orders;
import '../widgets/drawer.dart';
import '../widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});
  static String routeName = "/orders";

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      try {
        await Provider.of<Orders>(context).getData().then((_) => {
              setState(() {
                _isLoading = false;
              })
            });
      } catch (_) {
        await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: const Text("An error occurred"),
                  content: const Text("Something went wrong"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('/');
                        },
                        child: const Text("Ok")),
                  ],
                ));
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context).orders;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your orders"),
      ),
      drawer: const MyDrawer(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemBuilder: (_, index) => OrderItem(orderData[index]),
              itemCount: orderData.length,
            ),
    );
  }
}
