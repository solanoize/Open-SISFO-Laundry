import 'package:flutter/material.dart';
import 'package:open_sisfo_laundry/helpers/widgets.dart';
import 'package:open_sisfo_laundry/models/barang_model.dart';
import 'package:open_sisfo_laundry/providers/item_provider.dart';
import 'package:open_sisfo_laundry/repositories/barang_repository.dart';
import 'package:open_sisfo_laundry/screens/barang_screens/daftar_barang_screen.dart';
import 'package:open_sisfo_laundry/screens/terima_screens/form_terima_screen.dart';
import 'package:provider/provider.dart';

class PilihItemScreens extends StatefulWidget {
  const PilihItemScreens({super.key});

  @override
  State<PilihItemScreens> createState() => _PilihItemScreensState();
}

class _PilihItemScreensState extends State<PilihItemScreens> {
  /// MISC PROPERTIES

  /// CONTROLLER PROPERTIES

  /// FUTURE PROPERTIES
  Future<List<BarangModel>>? futureDaftarBarang;

  @override
  void initState() {
    super.initState();
    initFutureDaftarBarang();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => eventRefresh(),
      child: Scaffold(
        appBar: header(),
        body: futureBuilder(),
      ),
    );
  }

  /// INITS
  void initFutureDaftarBarang() {
    futureDaftarBarang = BarangRepository.reads();
  }

  /// HEADER
  AppBar header() {
    return AppBar(
      title: const Text("Pilih Item"),
      centerTitle: true,
      leading: leadingHeader(),
      actions: [
        actionHeaderBerikutnya(),
      ],
    );
  }

  /// LEADING HEADER
  Widget leadingHeader() {
    return GestureDetector(
      onTap: linkToHomeScreen,
      child: Icon(Icons.home_outlined),
    );
  }

  /// ACTIONS HEADER
  Consumer<ItemProvider> actionHeaderBerikutnya() {
    return Consumer<ItemProvider>(
      builder: (_, value, __) {
        bool isValid = value.isValidCart;
        return TextButton(
          onPressed: isValid ? linkToFormTerimaScreen : null,
          child: Text("Berikutnya"),
        );
      },
    );
  }

  /// BOTTOM ACTION
  ///

  /// FUTURE
  FutureBuilder<List<BarangModel>> futureBuilder() {
    return FutureBuilder<List<BarangModel>>(
      future: futureDaftarBarang,
      builder:
          (BuildContext context, AsyncSnapshot<List<BarangModel>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return problemWidget(context: context);
          }

          List<BarangModel> daftarBarang = snapshot.data!;
          if (daftarBarang.isEmpty) {
            return emptyWidget();
          }

          return layout(daftarBarang);
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }

  /// LAYOUT
  Widget layout(List<BarangModel> daftarBarang) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: collection(daftarBarang: daftarBarang),
          ),
        ],
      ),
    );
  }

  /// COLLECTION
  ListView collection({required List<BarangModel> daftarBarang}) {
    return ListView.separated(
      itemBuilder: (context, index) {
        return detail(barang: daftarBarang[index]);
      },
      separatorBuilder: (context, index) => Divider(),
      itemCount: daftarBarang.length,
    );
  }

  /// DETAIL
  ListTile detail({required BarangModel barang}) {
    var itemProvider = Provider.of<ItemProvider>(context, listen: false);

    return ListTile(
      title: Text(barang.nama),
      subtitle: Text(barang.deskripsi),
      trailing: FittedBox(
        fit: BoxFit.fill,
        child: Row(
          children: [
            IconButton(
              onPressed: () => eventDecreaseItem(
                itemProvider: itemProvider,
                barang: barang,
              ),
              icon: Icon(Icons.remove_circle_outline),
            ),
            Consumer<ItemProvider>(
              builder: (context, value, child) {
                int jumlah = value.getTotal(barang.barangId);
                return Text(
                  jumlah.toString(),
                );
              },
            ),
            IconButton(
              onPressed: () => eventIncreaseItem(
                itemProvider: itemProvider,
                barang: barang,
              ),
              icon: Icon(Icons.add_circle),
            ),
          ],
        ),
      ),
    );
  }

  /// INPUTS

  /// EVENTS
  void eventRefresh() async {
    setState(() {
      futureDaftarBarang = BarangRepository.reads();
    });
  }

  void eventDecreaseItem({
    required ItemProvider itemProvider,
    required BarangModel barang,
  }) {
    if (itemProvider.getTotal(barang.barangId) == 0) {
      return;
    }
    itemProvider.add(barang, -1);
  }

  void eventIncreaseItem({
    required ItemProvider itemProvider,
    required BarangModel barang,
  }) {
    itemProvider.add(barang, 1);
  }

  /// LINKS
  void linkToFormTerimaScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return FormTerimaScreen();
        },
      ),
    );
  }

  void linkToHomeScreen() {
    MaterialPageRoute mpr = MaterialPageRoute(
      builder: (context) => DaftarBarangScreen(),
    );
    Navigator.pushReplacement(context, mpr);
  }
}
