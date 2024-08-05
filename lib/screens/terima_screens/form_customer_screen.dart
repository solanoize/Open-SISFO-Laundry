import 'package:flutter/material.dart';

class FormCustomerScreen extends StatefulWidget {
  const FormCustomerScreen({super.key});

  @override
  State<FormCustomerScreen> createState() => _FormCustomerScreenState();
}

class _FormCustomerScreenState extends State<FormCustomerScreen> {
  String title = "Customer";
  final _formKey = GlobalKey<FormState>();
  TextEditingController namaCustomer = TextEditingController();
  TextEditingController teleponCustomer = TextEditingController();
  TextEditingController alamatCustomer = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
        centerTitle: true,
      ),
    );
  }
}
