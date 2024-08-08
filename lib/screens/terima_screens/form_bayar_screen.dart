import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_sisfo_laundry/providers/terima_provider.dart';
import 'package:open_sisfo_laundry/res/messages.dart';
import 'package:open_sisfo_laundry/res/spacing.dart';
import 'package:open_sisfo_laundry/screens/terima_screens/process_terima_screen.dart';
import 'package:provider/provider.dart';

class FormBayarScreen extends StatefulWidget {
  const FormBayarScreen({super.key});

  @override
  State<FormBayarScreen> createState() => _FormBayarScreenState();
}

class _FormBayarScreenState extends State<FormBayarScreen> {
  /// MISC PROPERTIES
  /// not implemented

  /// CONTROLLER PROPERTIES
  TextEditingController _dibayarController = TextEditingController();

  /// FUTURE PROPERTIES
  /// not implemented

  @override
  void initState() {
    super.initState();
    initController();
    initListener();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _dibayarController.dispose();
    super.dispose();
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
    final terimaProvider = Provider.of<TerimaProvider>(context, listen: false);
    _dibayarController.text = terimaProvider.terima.total.toString();
  }

  void initListener() {
    // Start listening to changes.
    _dibayarController.addListener(eventDibayar);
  }

  /// HEADER
  AppBar header() {
    return AppBar(
      title: Text("Pembayaran"),
      centerTitle: true,
    );
  }

  /// FUTURE
  /// not implemented

  /// LAYOUT
  Widget layout() {
    return SingleChildScrollView(
      child: Form(
        child: Column(
          children: [
            spaceAfterHeader(),
            infoWidgetStep(
              currentStep: 4,
              totalStep: 4,
              message: "Masukkan pembayaran tagihan cuci",
            ),
            spaceBetweenSection(),
            Divider(),
            widgetNomorTerima(),
            Divider(),
            widgetTotal(),
            Divider(),
            widgetSisa(),
            Divider(),
            widgetKembalian(),
            Divider(),
            widgetJenisPembayaran(),
            Divider(),
            spaceBetweenButtonOrInput(),
            spaceSide(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: inputDibayar(),
              ),
            ),
            spaceBetweenButtonOrInput(),
            spaceSide(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: widgetSelesai(),
              ),
            ),
            spaceEnd(),
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
  /// not implemented
  Widget widgetNomorTerima() {
    return ListTile(
      title: Text("Nomor Terima"),
      trailing: Consumer<TerimaProvider>(
        builder: (context, value, child) {
          return Text(value.terima.nomorTerima);
        },
      ),
    );
  }

  Widget widgetTotal() {
    return ListTile(
      title: Text("Total"),
      trailing: Consumer<TerimaProvider>(
        builder: (context, value, child) {
          return Text("Rp. ${value.terima.total}");
        },
      ),
    );
  }

  Widget widgetHargaPerKg() {
    return ListTile(
      title: Text("Harga Per Kg"),
      trailing: Consumer<TerimaProvider>(
        builder: (context, value, child) {
          return Text("Rp. ${value.terima.hargaPerKg}/kg");
        },
      ),
    );
  }

  Widget widgetBeratCucian() {
    return ListTile(
      title: Text("Berat Cucian"),
      trailing: Consumer<TerimaProvider>(
        builder: (context, value, child) {
          return Text("${value.terima.berat} kg");
        },
      ),
    );
  }

  Widget widgetSisa() {
    return ListTile(
      title: Text("Sisa"),
      trailing: Consumer<TerimaProvider>(
        builder: (context, value, child) {
          return Text("Rp. ${value.terima.sisa}");
        },
      ),
    );
  }

  Widget widgetKembalian() {
    return ListTile(
      title: Text("Kembalian"),
      trailing: Consumer<TerimaProvider>(
        builder: (context, value, child) {
          return Text("Rp. ${value.terima.total}");
        },
      ),
    );
  }

  Widget widgetJenisPembayaran() {
    return ListTile(
      title: Text("Jenis Pembayaran "),
      trailing: Consumer<TerimaProvider>(
        builder: (context, value, child) {
          return Text(value.terima.statusPembayaran);
        },
      ),
    );
  }

  Widget widgetSelesai() {
    return FilledButton(
      onPressed: eventSelesai,
      child: Text("Selesai"),
    );
  }

  /// INPUTS
  Widget inputDibayar() {
    return TextFormField(
      maxLength: 12,
      keyboardType: TextInputType.number,
      controller: _dibayarController,
      decoration: InputDecoration(labelText: "Dibayar"),
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

  ///////// OPTIONAL AREA //////////

  /// LEADING HEADER
  /// not implemented

  /// ACTIONS HEADER
  /// not implemented

  /// BOTTOM ACTION
  /// not implemented

  /// EVENTS
  void eventSelesai() {
    linkToProcessTerimaScreen();
  }

  void eventDibayar() {
    final terimaProvider = Provider.of<TerimaProvider>(context, listen: false);
    final String text = _dibayarController.text;
    if (text.isEmpty) {
      terimaProvider.dibayar(0);
    } else {
      terimaProvider.dibayar(int.parse(text));
    }
  }

  /// LINKS
  void linkToProcessTerimaScreen() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => ProcessTerimaScreen(),
      ),
      (Route<dynamic> route) => false, // Remove all routes beneath
    );
  }
}
