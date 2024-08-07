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
  /// MISC PROPERTIES
  final _formKey = GlobalKey<FormState>();
  DateTime _selectedDate = DateTime.now();
  bool _isProcess = false;

  /// CONTROLLER PROPERTIES
  TextEditingController _nomorTerimaController = TextEditingController();
  TextEditingController _tanggalController = TextEditingController();
  TextEditingController _beratController = TextEditingController();

  /// FUTURE PROPERTIES

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID');
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
    _tanggalController.text =
        DateFormat("d MMMM y", 'id').format(terimaProvider.terima.tanggal);
    _nomorTerimaController.text = terimaProvider.terima.nomorTerima;
    _beratController.text =
        _beratController.text = terimaProvider.terima.berat.toString();
  }

  /// HEADER
  AppBar header() {
    return AppBar(
      title: Text("Detail Terima"),
      centerTitle: true,
      actions: [
        TextButton(
          onPressed: _isProcess ? null : eventSimpan,
          child: Text("Berikutnya"),
        ),
      ],
    );
  }

  /// FUTURE

  /// LAYOUT
  Widget layout() {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Visibility(
              visible: _isProcess,
              child: LinearProgressIndicator(),
            ),
            inputNomorTerima(),
            inputTanggal(),
            inputBerat(),
          ],
        ),
      ),
    );
  }

  /// COLLECTION

  /// DETAIL

  /// INPUTS
  Widget inputNomorTerima() {
    return TextFormField(
      maxLength: 5,
      readOnly: true,
      controller: _nomorTerimaController,
      decoration: InputDecoration(
        labelText: "Nomor Terima",
        contentPadding: EdgeInsets.symmetric(horizontal: 16),
        alignLabelWithHint: true,
        suffixIcon: IconButton(
          icon: Icon(Icons.refresh),
          onPressed: eventGenerateNumber,
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

  Widget inputTanggal() {
    return TextFormField(
      readOnly: true,
      maxLength: 16,
      controller: _tanggalController,
      onTap: () => eventSelectedDate(context),
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

  Widget inputBerat() {
    return TextFormField(
      maxLength: 2,
      keyboardType: TextInputType.number,
      controller: _beratController,
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

  /// EVENTS
  void eventSimpan() {
    var terimaProvider = Provider.of<TerimaProvider>(context, listen: false);

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isProcess = true;
      });

      TerimaRepository.isUniqueNomorTerima(
        nomorTerima: _nomorTerimaController.text,
      ).then((bool result) {
        terimaProvider.nomorTerima(_nomorTerimaController.text);
        terimaProvider.tanggal(_selectedDate);
        terimaProvider.berat(int.parse(_beratController.text));

        HargaRepository.read().then((HargaModel harga) {
          terimaProvider.hargaPerKg(harga.hargaPerKg);
          linkToFormPelangganScreen();
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Terjadi kesalahan saat mengambil harga'),
          ));
        }).whenComplete(() {
          setState(() {
            _isProcess = false;
          });
        });
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Nomor terima sudah tersedia. ${error.toString()}'),
        ));
      });
    }
  }

  void eventGenerateNumber() {
    setState(() {
      _isProcess = true;
    });
    TerimaRepository.generateNomorterima().then((String nomor) {
      _nomorTerimaController.text = nomor;
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Kesalahan saat menghasilkan nomor terima.'),
      ));
    }).whenComplete(() {
      setState(() {
        _isProcess = false;
      });
    });
  }

  Future<void> eventSelectedDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _tanggalController.text = DateFormat("d MMMM y", 'id').format(picked);
      });
    }
  }

  /// LINKS
  void linkToFormPelangganScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return FormPelangganScreen();
        },
      ),
    );
  }
}
