import 'package:flutter/material.dart';
import 'package:open_sisfo_laundry/helpers/widgets.dart';
import 'package:open_sisfo_laundry/models/barang_model.dart';
import 'package:open_sisfo_laundry/repositories/barang_repository.dart';

class ConfirmDeleteBarangScreen extends StatefulWidget {
  const ConfirmDeleteBarangScreen({super.key, required this.barangId});

  final int barangId;

  @override
  State<ConfirmDeleteBarangScreen> createState() =>
      _ConfirmDeleteBarangScreenState();
}

class _ConfirmDeleteBarangScreenState extends State<ConfirmDeleteBarangScreen> {
  Future<BarangModel>? futureBarang;
  String title = "Hapus Barang";
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

          return layout(barang: barang);
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget layout({required BarangModel barang}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Visibility(
            visible: isProcess,
            child: LinearProgressIndicator(),
          ),
          SizedBox(height: 32),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Icon(
              Icons.info_rounded,
              color: Theme.of(context).colorScheme.error,
              size: 32,
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Anda yakin ingin mengapus data '${barang.nama}'? "
              "Data tidak akan bisa dikembalikan setelah dihapus.",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          SizedBox(height: 32),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: isProcess ? null : onHapus,
                    style: ButtonStyle(),
                    child: Text("Yakin"),
                  ),
                ),
                SizedBox(width: 24),
                Expanded(
                  flex: 2,
                  child: FilledButton(
                    onPressed:
                        isProcess ? null : () => Navigator.pop(context, false),
                    child: Text("Tidak Yakin"),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void onHapus() {
    setState(() {
      isProcess = true;
    });
    BarangRepository.delete(barangId: widget.barangId).then((bool status) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Berhasil menghapus data'),
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
