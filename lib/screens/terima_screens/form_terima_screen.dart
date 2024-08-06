import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:open_sisfo_laundry/helpers/misc.dart';
import 'package:open_sisfo_laundry/models/harga_model.dart';
import 'package:open_sisfo_laundry/providers/terima_provider.dart';
import 'package:open_sisfo_laundry/repositories/harga_repository.dart';
import 'package:open_sisfo_laundry/repositories/terima_repository.dart';
import 'package:open_sisfo_laundry/screens/terima_screens/form_customer_screen.dart';
import 'package:provider/provider.dart';

class FormTerimaScreen extends StatefulWidget {
  const FormTerimaScreen({super.key});

  @override
  State<FormTerimaScreen> createState() => _FormTerimaScreenState();
}

class _FormTerimaScreenState extends State<FormTerimaScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nomorTerimaController = TextEditingController();
  TextEditingController tanggalController = TextEditingController();
  TextEditingController beratController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  bool isProcess = false;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID');
    var terimaProvider = Provider.of<TerimaProvider>(context, listen: false);
    tanggalController.text =
        DateFormat("d MMMM y", 'id').format(terimaProvider.terima.tanggal);
    nomorTerimaController.text = terimaProvider.terima.nomorTerima;
    beratController.text =
        beratController.text = terimaProvider.terima.berat.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Detail Terima"),
        centerTitle: true,
      ),
      bottomNavigationBar: tombol(),
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
              nomorTerima(),
              SizedBox(height: 24),
              tanggal(),
              SizedBox(height: 24),
              berat(),
            ],
          ),
        ),
      ),
    );
  }

  Padding tombol() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: ElevatedButton(
              onPressed: isProcess ? null : () => Navigator.pop(context, false),
              child: Text("Batal"),
            ),
          ),
          SizedBox(width: 24),
          Expanded(
            flex: 2,
            child: FilledButton(
              onPressed: isProcess ? null : onSimpan,
              style: ButtonStyle(),
              child: Text("Lanjutkan"),
            ),
          ),
        ],
      ),
    );
  }

  Padding nomorTerima() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextFormField(
        maxLength: 5,
        readOnly: true,
        controller: nomorTerimaController,
        decoration: InputDecoration(
            labelText: "Nomor Terima",
            helperText: "* Wajib diisi",
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                TerimaRepository.generateNomorterima().then((String nomor) {
                  nomorTerimaController.text = nomor;
                });
              },
            )),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter some text';
          }

          if (value.length > 5) {
            return 'Panjang karakter maksimal 5 karakter';
          }

          return null;
        },
      ),
    );
  }

  Padding tanggal() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextFormField(
        readOnly: true,
        controller: tanggalController,
        onTap: () => onSelectedDate(context),
        decoration: InputDecoration(
          labelText: "Tanggal Terima",
          helperText: "* Wajib diisi",
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter some text';
          }

          return null;
        },
      ),
    );
  }

  Padding berat() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextFormField(
        maxLength: 2,
        keyboardType: TextInputType.number,
        controller: beratController,
        decoration: InputDecoration(
          labelText: "Berat Cucian (kg)",
          helperText: "* Wajib diisi",
          floatingLabelBehavior: FloatingLabelBehavior.always,
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
      ),
    );
  }

  void onSimpan() {
    /// Menggunakan provider listen false direkomendasikan, karena
    /// tidak dapat diguinakan di dalam build
    var terimaProvider = Provider.of<TerimaProvider>(context, listen: false);
    // check jika valid
    if (_formKey.currentState!.validate()) {
      /// Check nomor terima
      TerimaRepository.isUniqueNomorTerima(
        nomorTerima: nomorTerimaController.text,
      ).then((bool result) {
        terimaProvider.nomorTerima(nomorTerimaController.text);
        terimaProvider.tanggal(selectedDate);
        terimaProvider.berat(int.parse(beratController.text));
        HargaRepository.read().then((HargaModel harga) {
          terimaProvider.hargaPerKg(harga.hargaPerKg);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return FormPelangganScreen();
              },
            ),
          );
        });
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Nomor terima sudah tersedia. ${error.toString()}'),
        ));
      });
    }
  }

  Future<void> onSelectedDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        tanggalController.text = DateFormat("d MMMM y", 'id').format(picked);
      });
    }
  }
}
