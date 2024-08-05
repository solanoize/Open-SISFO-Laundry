import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:open_sisfo_laundry/helpers/widgets.dart';
import 'package:open_sisfo_laundry/models/barang_model.dart';
import 'package:open_sisfo_laundry/repositories/barang_repository.dart';

class UpdateBarangScreen extends StatefulWidget {
  const UpdateBarangScreen({super.key, required this.barangId});

  final int barangId;

  @override
  State<UpdateBarangScreen> createState() => _UpdateBarangScreenState();
}

class _UpdateBarangScreenState extends State<UpdateBarangScreen> {
  Future<BarangModel>? futureBarang;
  String title = "Update Barang";
  final _formKey = GlobalKey<FormState>();
  TextEditingController namaController = TextEditingController();
  TextEditingController deskripsiController = TextEditingController();
  bool isProcess = false;

  @override
  void initState() {
    super.initState();
    futureBarang = BarangRepository.read(barangId: widget.barangId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: Text(title),
      ),
      body: futureBuilder(),
    );
  }

  FutureBuilder<BarangModel> futureBuilder() {
    return FutureBuilder<BarangModel>(
      future: futureBarang,
      builder: (BuildContext context, AsyncSnapshot<BarangModel> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return problemWidget(context: context);
          }
          BarangModel barang = snapshot.data!;

          if (namaController.text.isEmpty && deskripsiController.text.isEmpty) {
            namaController.text = barang.nama;
            deskripsiController.text = barang.deskripsi;
          }
          return layout();
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget layout() {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Visibility(
              visible: isProcess,
              child: LinearProgressIndicator(),
            ),
            SizedBox(height: 32),
            namaBarang(),
            SizedBox(height: 32),
            deskripsiBarang(),
            SizedBox(height: 40),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: isProcess
                          ? null
                          : () => Navigator.pop(context, false),
                      child: Text("Batal"),
                    ),
                  ),
                  SizedBox(width: 24),
                  Expanded(
                    flex: 2,
                    child: FilledButton(
                      onPressed: isProcess ? null : onSimpan,
                      style: ButtonStyle(),
                      child: Text("Simpan"),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Padding namaBarang() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextFormField(
        maxLength: 20,
        controller: namaController,
        decoration: InputDecoration(
          labelText: "Nama barang",
          helperText: "* Wajib diisi",
          floatingLabelBehavior: FloatingLabelBehavior.always,
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
      ),
    );
  }

  Padding deskripsiBarang() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextFormField(
        maxLines: 3,
        maxLength: 50,
        controller: deskripsiController,
        decoration: InputDecoration(
          labelText: "Deskripsi barang",
          helperText: "* Wajib diisi",
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter some text';
          }

          if (value.length > 50) {
            return 'Panjang karakter maksimal 50 karakter';
          }

          return null;
        },
      ),
    );
  }

  void onSimpan() {
    // check jika valid
    if (_formKey.currentState!.validate()) {
      setState(() {
        isProcess = true;
      });
      BarangRepository.update(
        barangId: widget.barangId,
        nama: namaController.text,
        deskripsi: deskripsiController.text,
      ).then((barang) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Berhasil menyimpan data'),
        ));
        Navigator.pop(context, true);
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          content: Text(error.toString()),
        ));
      }).whenComplete(() {
        setState(() {
          isProcess = false;
        });
      });
    }
  }
}
