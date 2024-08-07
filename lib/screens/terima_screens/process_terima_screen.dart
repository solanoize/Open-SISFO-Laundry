import 'package:flutter/material.dart';
import 'package:open_sisfo_laundry/helpers/widgets.dart';
import 'package:open_sisfo_laundry/providers/item_provider.dart';
import 'package:open_sisfo_laundry/providers/terima_provider.dart';
import 'package:open_sisfo_laundry/repositories/terima_repository.dart';
import 'package:open_sisfo_laundry/screens/terima_screens/pilih_item_screen.dart';
import 'package:provider/provider.dart';

class ProcessTerimaScreen extends StatefulWidget {
  const ProcessTerimaScreen({super.key});

  @override
  State<ProcessTerimaScreen> createState() => _ProcessTerimaScreenState();
}

class _ProcessTerimaScreenState extends State<ProcessTerimaScreen> {
  /// MISC PROPERTIES
  /// not implemented

  /// CONTROLLER PROPERTIES
  /// not implemented

  /// FUTURE PROPERTIES
  Future<void>? futureTerima;

  @override
  void initState() {
    super.initState();
    initFuture();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(),
      body: futureBuilder(),
    );
  }

  /// INITS
  void initFuture() {
    var terimaProvider = Provider.of<TerimaProvider>(context, listen: false);
    var itemProvider = Provider.of<ItemProvider>(context, listen: false);
    futureTerima = TerimaRepository.createTransaction(
      terimaProvider,
      itemProvider,
    );
  }

  /// HEADER
  AppBar header() {
    return AppBar(
      title: Text("Proses Transaksi"),
      centerTitle: true,
    );
  }

  /// FUTURE
  FutureBuilder<void> futureBuilder() {
    return FutureBuilder<void>(
      future: futureTerima,
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return problemWidgetException(
              context: context,
              message: snapshot.error.toString(),
            );
          }
          return layout();
        }

        return widgetLoading();
      },
    );
  }

  /// LAYOUT
  Widget layout() {
    return Center(
      child: TextButton(onPressed: eventPilihItemScreen, child: Text("Sukses")),
    );
  }

  /// COLLECTION
  /// not implemented

  /// DETAIL
  /// not implemented

  /// WIDGETS
  Widget widgetLoading() {
    return Center(child: const CircularProgressIndicator());
  }

  /// INPUTS
  /// not implemented

  ///////// OPTIONAL AREA //////////

  /// LEADING HEADER
  /// not implemented

  /// ACTIONS HEADER
  /// not implemented

  /// BOTTOM ACTION
  /// not implemented

  /// EVENTS
  /// not implemented
  void eventPilihItemScreen() {
    linkToPilihItemScreen();
  }

  /// LINKS
  void linkToPilihItemScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => PilihItemScreens()),
    );
  }
}
