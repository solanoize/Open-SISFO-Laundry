import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
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
        title: Text("Detail Terima"),
        centerTitle: true,
        actions: [
          TextButton(onPressed: onSimpan, child: Text("Berikutnya")),
        ],
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
              nomorTerima(),
              tanggal(),
              berat(),
            ],
          ),
        ),
      ),
    );
  }

  Widget nomorTerima() {
    return TextFormField(
      maxLength: 5,
      readOnly: true,
      controller: nomorTerimaController,
      decoration: InputDecoration(
        labelText: "Nomor Terima",
        contentPadding: EdgeInsets.symmetric(horizontal: 16),
        alignLabelWithHint: true,
        suffixIcon: IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () {
            TerimaRepository.generateNomorterima().then((String nomor) {
              nomorTerimaController.text = nomor;
            });
          },
        ),
      ),
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

  Widget tanggal() {
    return TextFormField(
      readOnly: true,
      maxLength: 16,
      controller: tanggalController,
      onTap: () => onSelectedDate(context),
      decoration: InputDecoration(
        labelText: "Tanggal Terima",
        contentPadding: EdgeInsets.symmetric(horizontal: 16),
        alignLabelWithHint: true,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }

        return null;
      },
    );
  }

  Widget berat() {
    return TextFormField(
      maxLength: 2,
      keyboardType: TextInputType.number,
      controller: beratController,
      decoration: InputDecoration(
        labelText: "Berat Cucian (kg)",
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
