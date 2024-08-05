import 'package:flutter/material.dart';
import 'package:open_sisfo_laundry/repositories/barang_repository.dart';

class CreateBarangScreen extends StatefulWidget {
  const CreateBarangScreen({super.key});

  @override
  State<CreateBarangScreen> createState() => CreateBarangScreenState();
}

class CreateBarangScreenState extends State<CreateBarangScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController namaController = TextEditingController();
  TextEditingController deskripsiController = TextEditingController();
  bool isProcess = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Buat Barang"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
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
                        onPressed:
                            isProcess ? null : () => Navigator.pop(context),
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
      BarangRepository.create(
        nama: namaController.text,
        deskripsi: deskripsiController.text,
      ).then((barang) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Berhasil menyimpan data'),
        ));
        Navigator.pop(context);
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          content: Text('Data tidak dapat disimpan'),
        ));
      }).whenComplete(() {
        setState(() {
          isProcess = false;
        });
      });
    }
  }
}
