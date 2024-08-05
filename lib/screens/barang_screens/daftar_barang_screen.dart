import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:open_sisfo_laundry/helpers/widgets.dart';
import 'package:open_sisfo_laundry/models/barang_model.dart';
import 'package:open_sisfo_laundry/repositories/barang_repository.dart';
import 'package:open_sisfo_laundry/screens/barang_screens/create_barang_screen.dart';
import 'package:open_sisfo_laundry/screens/barang_screens/update_barang_screen.dart';

Drawer drawer(BuildContext context, GlobalKey<ScaffoldState> key) => Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Laundry",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                Text(
                  "Open Sistem Informasi Laundry 1.0.0",
                  style: Theme.of(context).textTheme.bodyMedium,
                )
              ],
            ),
          ),
          SizedBox(
            height: 24,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Master",
              style: TextStyle(
                color: Colors.black54,
              ),
            ),
          ),
          ListTile(
            title: const Text('Daftar Barang'),
            leading: Icon(Icons.inventory_2_outlined),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            title: const Text('Barang Baru'),
            leading: Icon(Icons.add),
            onTap: () {
              key.currentState?.closeDrawer();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return CreateBarangScreen();
                  },
                ),
              );
            },
          ),
          SizedBox(
            height: 16,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Transaksi",
              style: TextStyle(
                color: Colors.black54,
              ),
            ),
          ),
          ListTile(
            title: const Text('Terima Cucian'),
            leading: Icon(Icons.shopping_bag_outlined),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            title: const Text('Cucian Selesai'),
            leading: Icon(Icons.dry_cleaning_outlined),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            title: const Text('Ambil Cucian'),
            leading: Icon(Icons.people_alt_outlined),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          SizedBox(
            height: 16,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Lainnya",
              style: TextStyle(
                color: Colors.black54,
              ),
            ),
          ),
          ListTile(
            title: const Text('Laporan Periodik'),
            leading: Icon(Icons.receipt_long_outlined),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            title: const Text('Pengaturan'),
            leading: Icon(Icons.settings_outlined),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
        ],
      ),
    );

enum ActionItem {
  actionUpdate,
  actionDelete,
}

class DaftarBarangScreen extends StatefulWidget {
  const DaftarBarangScreen({super.key});

  @override
  State<DaftarBarangScreen> createState() => _DaftarBarangScreenState();
}

class _DaftarBarangScreenState extends State<DaftarBarangScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Future<List<BarangModel>>? futureDaftarBarang;
  ActionItem? selectedAction;
  String title = "Barang";

  @override
  void initState() {
    super.initState();
    futureDaftarBarang = BarangRepository.reads();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: Text(title),
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: Icon(Icons.menu),
            );
          },
        ),
      ),
      body: futureBuilder(),
      drawer: drawer(context, _scaffoldKey),
    );
  }

  FutureBuilder<List<BarangModel>> futureBuilder() {
    return FutureBuilder<List<BarangModel>>(
      future: futureDaftarBarang,
      builder:
          (BuildContext context, AsyncSnapshot<List<BarangModel>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            log("[DaftarBarangScreen] ${snapshot.error.toString()}");
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
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(daftarBarang[index].nama),
                  subtitle: Text(daftarBarang[index].deskripsi),
                  trailing: popupMenu(barangId: daftarBarang[index].barangId),
                );
              },
              separatorBuilder: (context, index) => Divider(),
              itemCount: daftarBarang.length,
            ),
          )
        ],
      ),
    );
  }

  PopupMenuButton<ActionItem> popupMenu({required int barangId}) {
    return PopupMenuButton<ActionItem>(
      initialValue: selectedAction,
      onSelected: (ActionItem item) {
        if (item == ActionItem.actionDelete) {
          log("Delete screen");
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return UpdateBarangScreen(barangId: barangId);
              },
            ),
          );
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<ActionItem>>[
        const PopupMenuItem<ActionItem>(
          value: ActionItem.actionUpdate,
          child: Text("Edit"),
        ),
        const PopupMenuItem<ActionItem>(
          value: ActionItem.actionDelete,
          child: Text("Delete"),
        ),
      ],
    );
  }
}
