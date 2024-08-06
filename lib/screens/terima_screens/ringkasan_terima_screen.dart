import 'package:flutter/material.dart';
import 'package:open_sisfo_laundry/providers/item_provider.dart';
import 'package:open_sisfo_laundry/providers/terima_provider.dart';
import 'package:open_sisfo_laundry/screens/terima_screens/form_bayar_screen.dart';
import 'package:provider/provider.dart';

class RingkasanTerimaScreen extends StatefulWidget {
  const RingkasanTerimaScreen({super.key});

  @override
  State<RingkasanTerimaScreen> createState() => _RingkasanTerimaScreenState();
}

class _RingkasanTerimaScreenState extends State<RingkasanTerimaScreen> {
  @override
  Widget build(BuildContext context) {
    var terimaProvider = context.watch<TerimaProvider>();
    var itemProvider = context.watch<ItemProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ringkasan"),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return FormBayarScreen();
                  },
                ),
              );
            },
            child: Text("Pembayaran"),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: item(
                    title: "Nomor Terima",
                    consumer: Consumer(
                      builder: (context, value, child) {
                        return Text(terimaProvider.terima.nomorTerima);
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: item(
                    title: "Tanggal Terima",
                    consumer: Consumer(
                      builder: (context, value, child) {
                        return Text(terimaProvider.terima.tanggal.toString());
                      },
                    ),
                  ),
                ),
              ],
            ),
            Divider(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: item(
                    title: "Rincian Harga",
                    consumer: Consumer(
                      builder: (context, value, child) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                "Harga Rp.${terimaProvider.terima.hargaPerKg}/kg"),
                            Text(
                                "Berat ${terimaProvider.terima.berat}Kg x Rp.${terimaProvider.terima.hargaPerKg}"),
                            Text("Total Rp.${terimaProvider.terima.total}"),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: item(
                    title: "Pelanggan",
                    consumer: Consumer(
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
                  ),
                ),
              ],
            ),
            Divider(),
            ListTile(
              title: Text(
                "Rincian Item",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) => Divider(),
                itemCount: itemProvider.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(itemProvider.items[index].nama),
                    trailing: Text("${itemProvider.items[index].jumlah} item"),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  ListTile item({
    required String title,
    required Consumer<TerimaProvider> consumer,
  }) {
    return ListTile(
      title: Text(title),
      subtitle: consumer,
    );
  }
}
