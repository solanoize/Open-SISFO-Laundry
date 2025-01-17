import 'package:flutter/material.dart';
import 'package:open_sisfo_laundry/models/item_model.dart';
import 'package:open_sisfo_laundry/providers/item_provider.dart';
import 'package:open_sisfo_laundry/providers/terima_provider.dart';
import 'package:open_sisfo_laundry/res/messages.dart';
import 'package:open_sisfo_laundry/res/sizes.dart';
import 'package:open_sisfo_laundry/res/spacing.dart';
import 'package:open_sisfo_laundry/screens/terima_screens/form_bayar_screen.dart';
import 'package:provider/provider.dart';

class RingkasanTerimaScreen extends StatefulWidget {
  const RingkasanTerimaScreen({super.key});

  @override
  State<RingkasanTerimaScreen> createState() => _RingkasanTerimaScreenState();
}

class _RingkasanTerimaScreenState extends State<RingkasanTerimaScreen> {
  /// MISC PROPERTIES
  /// not implemented

  /// CONTROLLER PROPERTIES
  /// not implemented

  /// FUTURE PROPERTIES
  /// not implemented

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(),
      body: layout(),
    );
  }

  /// INITS
  /// not implemented

  /// HEADER
  AppBar header() {
    return AppBar(
      title: const Text("Ringkasan"),
      centerTitle: true,
    );
  }

  /// FUTURE
  /// not implemented

  /// LAYOUT
  Widget layout() {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          spaceAfterHeader(),
          infoWidgetStep(
            currentStep: 3,
            totalStep: 4,
            message: "Ringkasan penerimaan cucian",
          ),
          spaceBetweenSection(),
          spaceBetweenTitleAndContent(
            child: spaceSide(
              child: widgetInfoDasar(),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: widgetNomorTerima()),
              Expanded(child: widgetTanggalTerima()),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: widgetRincianHarga()),
              Expanded(child: wigdetPelanggan()),
            ],
          ),
          spaceBetweenSection(),
          spaceBetweenTitleAndContent(
            child: spaceSide(
              child: widgetRincianItem(),
            ),
          ),
          Expanded(child: collection()),
          spaceBetweenButtonOrInput(),
          spaceSide(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: widgetPembayaran(),
            ),
          ),
          spaceEnd(),
        ],
      ),
    );
  }

  /// COLLECTION
  Widget collection() {
    var itemProvider = context.watch<ItemProvider>();
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(),
      itemCount: itemProvider.length,
      itemBuilder: (context, index) {
        return detail(item: itemProvider.items[index]);
      },
    );
  }

  /// DETAIL
  Widget detail({required ItemModel item}) {
    return ListTile(
      title: Text(item.nama),
      trailing: Text("${item.jumlah} item"),
    );
  }

  /// WIDGETS
  Widget widgetRincianItem() {
    return Text(
      "Rincian Item",
      style: Theme.of(context).textTheme.titleMedium,
    );
  }

  Widget widgetInfoDasar() {
    return Text(
      "Info Dasar",
      style: Theme.of(context).textTheme.titleMedium,
    );
  }

  Widget wigdetPelanggan() {
    var terimaProvider = context.watch<TerimaProvider>();
    return ListTile(
      title: Text("Pelanggan"),
      subtitle: Consumer(
        builder: (context, value, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(terimaProvider.terima.namaPelanggan),
              Text(terimaProvider.terima.teleponPelanggan),
              Text(terimaProvider.terima.alamatPelanggan)
            ],
          );
        },
      ),
    );
  }

  Widget widgetRincianHarga() {
    var terimaProvider = context.watch<TerimaProvider>();
    return ListTile(
      title: Text("Rincian Harga"),
      subtitle: Consumer(
        builder: (context, value, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Harga Rp.${terimaProvider.terima.hargaPerKg}/kg"),
              Text(
                  "Berat ${terimaProvider.terima.berat}Kg x Rp.${terimaProvider.terima.hargaPerKg}"),
              Text("Total Rp.${terimaProvider.terima.total}"),
            ],
          );
        },
      ),
    );
  }

  Widget widgetTanggalTerima() {
    var terimaProvider = context.watch<TerimaProvider>();
    return ListTile(
      title: Text("Tanggal Terima"),
      subtitle: Consumer(
        builder: (context, value, child) {
          return Text(terimaProvider.terima.tanggal.toString());
        },
      ),
      contentPadding: EdgeInsets.symmetric(
        vertical: 0,
        horizontal: size16,
      ),
    );
  }

  Widget widgetNomorTerima() {
    var terimaProvider = context.watch<TerimaProvider>();

    return ListTile(
      title: Text("Nomor Terima"),
      subtitle: Consumer(
        builder: (context, value, child) {
          return Text(terimaProvider.terima.nomorTerima);
        },
      ),
      contentPadding: EdgeInsets.symmetric(
        vertical: 0,
        horizontal: size16,
      ),
    );
  }

  Widget widgetPembayaran() {
    return FilledButton(
      onPressed: eventFormPembayaranScreen,
      child: Text("Pembayaran"),
    );
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
  void eventFormPembayaranScreen() {
    linkToFormPembayaranScreen();
  }

  /// LINKS
  void linkToFormPembayaranScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return FormBayarScreen();
        },
      ),
    );
  }
}
