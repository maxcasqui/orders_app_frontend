import 'package:flutter/material.dart';
import 'package:orders_app/models/order_model.dart';
import '../data/api_service.dart';
import '../models/product_model.dart';

class AddPage extends StatefulWidget {

  final bool existsID;
  final Order? order;

  const AddPage({super.key, required this.existsID, this.order});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {

  late TextEditingController orderNumberController = TextEditingController();
  late TextEditingController orderdateController = TextEditingController();
  late TextEditingController productsnumberController = TextEditingController();
  late TextEditingController finalPriceController = TextEditingController();

  final ApiService apiService = ApiService();
  List<Product> products = [];
  late Product selectedProduct;
  late int quantity;
  late Order order;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    orderNumberController.dispose();
    orderdateController.dispose();
    productsnumberController.dispose();
    finalPriceController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    order = widget.order ?? Order(id: 0, orderNumber: '', orderDate: DateTime.now(), numProducts: 0, finalPrice: 0.0);
    selectedProduct = Product(productId: 0, productName: '', unitPrice: 0.0);
    quantity = 1;

    orderNumberController = TextEditingController(text: order.orderNumber);
    orderdateController = TextEditingController(text: order.orderDate.toString());
    productsnumberController = TextEditingController(text: order.numProducts.toString());
    finalPriceController = TextEditingController(text: "S/. ${order.finalPrice}");
    fetchProducts();
  }

  void fetchProducts() async {
    try {
      final data = await apiService.listProducts();
      setState(() {
        products = data;
        selectedProduct = products.isNotEmpty ? products.first : Product(productId: 0, productName: '', unitPrice: 0.0);
      });
    } catch (e) {
      print(e);
    }
  }

  void addProductToOrder(int orderId, int productId, int quantity) async {
    try {
      await apiService.addProductToOrder(orderId, productId, quantity);
      print('Product added successfully');
    } catch (e) {
      print(e);
    }
  }

  void addOrder(String orderNumber, DateTime orderDate) async {
    try {
      await apiService.addOrder(orderNumber, orderDate);
      print('Product added successfully');
    } catch (e) {
      print(e);
    }
  }

  void _navigateToAddPageWithNewOrder() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const AddPage(existsID: false),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existsID ? 'Edit Order' : 'Add Order'),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: getBody(widget.existsID, context),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: _navigateToAddPageWithNewOrder,
        child: const Icon(Icons.add, color: Colors.white)
      )
    );
  }

  void _openAddProductModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Product to Order'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<Product>(
                value: selectedProduct,
                onChanged: (Product? value) {
                  if (value != null) {
                    setState(() {
                      selectedProduct = value;
                    });
                  }
                },
                items: products
                    .map((product) => DropdownMenuItem<Product>(
                          value: product,
                          child: Text(product.productName),
                        ))
                    .toList(),
                decoration: const InputDecoration(labelText: 'Select Product'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: '1',
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    if (value.isNotEmpty){
                      quantity = int.parse(value);
                    }
                  });
                },
                decoration: const InputDecoration(labelText: 'Quantity'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                int newQuantity = int.parse(productsnumberController.text) + quantity;
                double newFinalPrice = double.parse(finalPriceController.text.split(" ")[1]) + (selectedProduct.unitPrice * quantity);
                productsnumberController.text = newQuantity.toString();
                finalPriceController.text = "S/. ${newFinalPrice.round()}";
                addProductToOrder(order.id, selectedProduct.productId, quantity);
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ]
        );
      },
    );
  }

  Widget getBody(bool existsID, BuildContext context){

    return SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Order #'),
              TextFormField(
                controller: orderNumberController,
                onChanged: (value) {
                  setState(() {
                    order.orderNumber = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              const Text('Date'),
              TextFormField(
                enabled: false,
                controller: orderdateController,
              ),
              const SizedBox(height: 16),
              const Text('# Products'),
              TextFormField(
                enabled: false,
                controller: productsnumberController,
              ),
              const SizedBox(height: 16),
              const Text('Final Price'),
              TextFormField(
                enabled: false,
                controller: finalPriceController,
              ),
              const SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (existsID){
                      _openAddProductModal(context);
                    } else {
                      // create order
                      addOrder(orderNumberController.text.toString(), orderdateController.text as DateTime);
                      // add product
                    }
                  },
                  child: Text(existsID ? 'Add Product' : 'Create Order'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
    );
  }
}