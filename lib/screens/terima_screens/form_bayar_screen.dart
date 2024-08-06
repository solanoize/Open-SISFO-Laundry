import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:open_sisfo_laundry/providers/terima_provider.dart';
import 'package:provider/provider.dart';

class FormBayarScreen extends StatefulWidget {
  const FormBayarScreen({super.key});

  @override
  State<FormBayarScreen> createState() => _FormBayarScreenState();
}

class _FormBayarScreenState extends State<FormBayarScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController dibayarController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    dibayarController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    final terimaProvider = Provider.of<TerimaProvider>(context, listen: false);
    dibayarController.text = terimaProvider.terima.total.toString();
    // Start listening to changes.
    dibayarController.addListener(_onDibayar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pembayaran"),
        centerTitle: true,
        actions: [
          TextButton(onPressed: () {}, child: Text("Selesai")),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ListTile(
                      title: Text("Nomor Terima"),
                      subtitle: Consumer<TerimaProvider>(
                        builder: (context, value, child) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(value.terima.nomorTerima),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: Text("Total"),
                      subtitle: Consumer<TerimaProvider>(
                        builder: (context, value, child) {
                          return Text("Rp. ${value.terima.total}");
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ListTile(
                      title: Text("Harga Per Kg"),
                      subtitle: Consumer<TerimaProvider>(
                        builder: (context, value, child) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Rp. ${value.terima.hargaPerKg}/kg"),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: Text("Berat Cucian"),
                      subtitle: Consumer<TerimaProvider>(
                        builder: (context, value, child) {
                          return Text("${value.terima.berat} kg");
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ListTile(
                      title: Text("Sisa"),
                      subtitle: Consumer<TerimaProvider>(
                        builder: (context, value, child) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Rp. ${value.terima.sisa}"),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: Text("Kembalian"),
                      subtitle: Consumer<TerimaProvider>(
                        builder: (context, value, child) {
                          return Text("Rp. ${value.terima.total}");
                        },
                      ),
                    ),
                  ),
                ],
              ),
              dibayar(),
              ListTile(
                title: Text("Jenis Pembayaran "),
                subtitle: Consumer<TerimaProvider>(
                  builder: (context, value, child) {
                    return Text(value.terima.statusPembayaran);
                  },
                ),
              ),
              SizedBox(
                height: 32,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget dibayar() {
    return TextFormField(
      maxLength: 12,
      keyboardType: TextInputType.number,
      controller: dibayarController,
      decoration: InputDecoration(
        labelText: "Dibayar",
        contentPadding: EdgeInsets.symmetric(horizontal: 16),
        alignLabelWithHint: true,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        FilteringTextInputFormatter.digitsOnly,
      ],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }

        if (value.length > 5) {
          return 'Panjang karakter maksimal 5 karakter';
        }

        return null;
      },
    );
  }

  void _onDibayar() {
    final terimaProvider = Provider.of<TerimaProvider>(context, listen: false);
    final String text = dibayarController.text;
    if (text.isEmpty) {
      terimaProvider.dibayar(0);
    } else {
      terimaProvider.dibayar(int.parse(text));
    }
  }
}
