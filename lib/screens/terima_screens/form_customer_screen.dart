import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:open_sisfo_laundry/providers/terima_provider.dart';
import 'package:open_sisfo_laundry/res/messages.dart';
import 'package:open_sisfo_laundry/res/spacing.dart';
import 'package:open_sisfo_laundry/screens/terima_screens/ringkasan_terima_screen.dart';
import 'package:provider/provider.dart';

class FormPelangganScreen extends StatefulWidget {
  const FormPelangganScreen({super.key});

  @override
  State<FormPelangganScreen> createState() => _FormPelangganScreenState();
}

class _FormPelangganScreenState extends State<FormPelangganScreen> {
  /// MISC PROPERTIES
  final _formKey = GlobalKey<FormState>();

  /// CONTROLLER PROPERTIES
  TextEditingController _namaPelangganController = TextEditingController();
  TextEditingController _teleponPelangganController = TextEditingController();
  TextEditingController _alamatPelangganController = TextEditingController();

  /// FUTURE PROPERTIES
  /// not implemented here.

  @override
  void initState() {
    super.initState();
    initController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(),
      body: layout(),
    );
  }

  /// INITS
  void initController() {
    var terimaProvider = Provider.of<TerimaProvider>(context, listen: false);
    _namaPelangganController.text = terimaProvider.terima.namaPelanggan;
    _teleponPelangganController.text = terimaProvider.terima.teleponPelanggan;
    _alamatPelangganController.text = terimaProvider.terima.alamatPelanggan;
  }

  /// HEADER
  AppBar header() {
    return AppBar(
      title: const Text("Pelanggan"),
      centerTitle: true,
    );
  }

  /// LEADING HEADER
  /// not implemented

  /// ACTIONS HEADER
  /// not implemented

  /// BOTTOM ACTION
  /// not implemented

  /// FUTURE
  /// not implemented

  /// LAYOUT
  Widget layout() {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            spaceAfterHeader(),
            infoWidgetStep(
              currentStep: 2,
              totalStep: 4,
              message: "Masukkan informasi pelanggan/customer",
            ),
            spaceBetweenSection(),
            spaceSide(child: inputNamaPelanggan()),
            spaceBetweenButtonOrInput(),
            spaceSide(child: inputTeleponPelanggan()),
            spaceBetweenButtonOrInput(),
            spaceSide(child: inputAlamatPelanggan()),
            spaceBetweenButtonOrInput(),
            spaceSide(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: widgetBerikutnya(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// COLLECTION
  /// not implemented

  /// DETAIL
  /// not implemented

  /// WIDGETS
  Widget widgetBerikutnya() {
    return FilledButton(
      onPressed: eventBerikutnya,
      child: Text("Berikutnya"),
    );
  }

  /// INPUTS
  TextFormField inputNamaPelanggan() {
    return TextFormField(
      maxLength: 20,
      controller: _namaPelangganController,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: "Nama ",
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

  TextFormField inputTeleponPelanggan() {
    return TextFormField(
      maxLength: 13,
      textInputAction: TextInputAction.next,
      controller: _teleponPelangganController,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: "Telepon",
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

  TextFormField inputAlamatPelanggan() {
    return TextFormField(
      maxLength: 100,
      maxLines: 5,
      textInputAction: TextInputAction.done,
      controller: _alamatPelangganController,
      decoration: InputDecoration(
        labelText: "Alamat",
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

  /// EVENTS
  void eventBerikutnya() {
    if (_formKey.currentState!.validate()) {
      var provider = Provider.of<TerimaProvider>(context, listen: false);
      provider.namaPelanggan(_namaPelangganController.text);
      provider.teleponPelanggan(_teleponPelangganController.text);
      provider.alamatPelanggan(_alamatPelangganController.text);
      linkToRingkasanTerimaScreen();
    }
  }

  /// LINKS
  void linkToRingkasanTerimaScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return RingkasanTerimaScreen();
      }),
    );
  }
}
