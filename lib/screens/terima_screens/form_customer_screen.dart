import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:open_sisfo_laundry/providers/terima_provider.dart';
import 'package:open_sisfo_laundry/screens/terima_screens/ringkasan_terima_screen.dart';
import 'package:provider/provider.dart';

class FormPelangganScreen extends StatefulWidget {
  const FormPelangganScreen({super.key});

  @override
  State<FormPelangganScreen> createState() => _FormPelangganScreenState();
}

class _FormPelangganScreenState extends State<FormPelangganScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController namaPelangganController = TextEditingController();
  TextEditingController teleponPelangganController = TextEditingController();
  TextEditingController alamatPelangganController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    var terimaProvider = Provider.of<TerimaProvider>(context, listen: false);
    namaPelangganController.text = terimaProvider.terima.namaPelanggan;
    teleponPelangganController.text = terimaProvider.terima.teleponPelanggan;
    alamatPelangganController.text = terimaProvider.terima.alamatPelanggan;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pelanggan"),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                var provider =
                    Provider.of<TerimaProvider>(context, listen: false);
                provider.namaPelanggan(namaPelangganController.text);
                provider.teleponPelanggan(teleponPelangganController.text);
                provider.alamatPelanggan(alamatPelangganController.text);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return RingkasanTerimaScreen();
                  }),
                );
              }
            },
            child: Text(
              "Berikutnya",
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // SizedBox(height: 32),
              namaPelanggan(),
              teleponPelanggan(),
              alamatPelanggan(),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField namaPelanggan() {
    return TextFormField(
      maxLength: 20,
      controller: namaPelangganController,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: "Nama ",
        contentPadding: EdgeInsets.symmetric(horizontal: 16),
        alignLabelWithHint: true,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }

        if (value.length > 20) {
          return 'Panjang karakter maksimal 20 karakter';
        }

        return null;
      },
    );
  }

  TextFormField teleponPelanggan() {
    return TextFormField(
      maxLength: 13,
      textInputAction: TextInputAction.next,
      controller: teleponPelangganController,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: "Telepon",
        contentPadding: EdgeInsets.symmetric(horizontal: 16),
        alignLabelWithHint: true,
      ),
      onFieldSubmitted: (value) {
        log("test");
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }

        if (value.length > 13) {
          return 'Panjang karakter maksimal 13 karakter';
        }

        return null;
      },
    );
  }

  TextFormField alamatPelanggan() {
    return TextFormField(
      maxLength: 100,
      maxLines: 5,
      textInputAction: TextInputAction.done,
      controller: alamatPelangganController,
      decoration: InputDecoration(
        labelText: "Alamat",
        contentPadding: EdgeInsets.symmetric(horizontal: 16),
        alignLabelWithHint: true,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }

        if (value.length > 100) {
          return 'Panjang karakter maksimal 100 karakter';
        }

        return null;
      },
    );
  }
}
