import 'package:flutter/material.dart';
import 'package:open_sisfo_laundry/helpers/widgets.dart';
import 'package:open_sisfo_laundry/models/barang_model.dart';
import 'package:open_sisfo_laundry/providers/item_provider.dart';
import 'package:open_sisfo_laundry/repositories/barang_repository.dart';
import 'package:open_sisfo_laundry/screens/terima_screens/form_terima_screen.dart';
import 'package:provider/provider.dart';

class PilihItemScreens extends StatefulWidget {
  const PilihItemScreens({super.key});

  @override
  State<PilihItemScreens> createState() => _PilihItemScreensState();
}

class _PilihItemScreensState extends State<PilihItemScreens> {
  Future<List<BarangModel>>? futureDaftarBarang;

  @override
  void initState() {
    super.initState();
    futureDaftarBarang = BarangRepository.reads();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          futureDaftarBarang = BarangRepository.reads();
        });
      },
      child: Scaffold(
        appBar: AppBar(
          // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          centerTitle: true,
          title: const Text("Pilih Item"),
          actions: [
            Consumer<ItemProvider>(
              builder: (_, value, __) {
                bool isValid = value.isValidCart;
                return TextButton(
                  onPressed: isValid
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return FormTerimaScreen();
                              },
                            ),
                          );
                        }
                      : null,
                  child: Text("Berikutnya"),
                );
              },
            )
          ],
        ),
        body: futureBuilder(),
      ),
    );
  }

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

  SafeArea layout(List<BarangModel> daftarBarang) {
    var itemProvider = context.watch<ItemProvider>();
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemBuilder: (context, index) {
                return detail(itemProvider, daftarBarang, index);
              },
              separatorBuilder: (context, index) => Divider(),
              itemCount: daftarBarang.length,
            ),
          ),
        ],
      ),
    );
  }

  ListTile detail(
    ItemProvider itemProvider,
    List<BarangModel> daftarBarang,
    int index,
  ) {
    /// TODO: need improvement with Provider listen false.
    /// var itemProvider2 = Provider.of<ItemProvider>(context, listen: false);
    return ListTile(
      onTap: () {
        itemProvider.add(daftarBarang[index], -1);
      },
      title: Text(daftarBarang[index].nama),
      subtitle: Text(daftarBarang[index].deskripsi),
      selected: itemProvider.selected(daftarBarang[index].barangId),
      trailing: FittedBox(
        fit: BoxFit.fill,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                if (itemProvider.getTotal(daftarBarang[index].barangId) == 0) {
                  return;
                }
                itemProvider.add(daftarBarang[index], -1);
              },
              icon: Icon(Icons.remove_circle_outline),
            ),
            Consumer<ItemProvider>(
              builder: (context, value, child) {
                int jumlah = value.getTotal(daftarBarang[index].barangId);
                return Text(
                  jumlah.toString(),
                );
              },
            ),
            IconButton(
              onPressed: () {
                itemProvider.add(daftarBarang[index], 1);
              },
              icon: Icon(Icons.add_circle),
            ),
          ],
        ),
      ),
    );
  }
}
