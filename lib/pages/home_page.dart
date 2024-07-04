import 'package:flutter/material.dart';
import 'package:orders_app/components/order_card.dart';
import 'package:orders_app/main.dart';
import 'package:orders_app/pages/add_page.dart';
import 'package:orders_app/data/api_service.dart';
import 'package:orders_app/models/order_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with RouteAware {

  final ApiService apiService = ApiService();
  List<Order> orders = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute<dynamic>);
    fetchOrders();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    fetchOrders();
  }

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  void fetchOrders() async {
    try {
      final data = await apiService.listOrders();
      setState(() {
        orders = data;
      });
    } catch (e) {
      print(e);
    }
  }

  void deleteOrder(int orderId) async {
    try {
      final result = await apiService.deleteOrder(orderId);
      fetchOrders();
      print(result);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("My Orders"),
        centerTitle: true,
      ),

      body: getBody(),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add, color: Colors.white,),
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddPage(existsID: false))
          );
        }
      ),
    );
  }

  Widget getBody(){
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return OrderCard(
          order: order,
          editFunction: (context) => {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddPage(existsID: true, order: order,))
            )
          },
          deleteFunction: (context) => {
            showDialog(
              context: context,
              builder: (context){
                return AlertDialog(
                  title: const Text('Confirm Delete'),
                  content: Text('Are you sure you want to delete order ${order.orderNumber}?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        deleteOrder(order.id);
                        Navigator.of(context).pop();
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                );
              }
            )
          },
        );
      },
    );
  }
}