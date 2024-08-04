import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:open_sisfo_laundry/helpers/widgets.dart';
import 'package:open_sisfo_laundry/models/Barang.dart';
import 'package:open_sisfo_laundry/repositories/barang_repository.dart';

Drawer drawer(BuildContext context) => Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
            child: Text(
              "Laundry",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
          ListTile(
            title: const Text('Daftar Barang'),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          )
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
  Future<List<Barang>>? futureDaftarBarang;
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
      drawer: drawer(context),
    );
  }

  FutureBuilder<List<Barang>> futureBuilder() {
    return FutureBuilder<List<Barang>>(
      future: futureDaftarBarang,
      builder: (BuildContext context, AsyncSnapshot<List<Barang>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            log("[DaftarBarangScreen] ${snapshot.error.toString()}");
            return problemWidget(context: context);
          }

          List<Barang> daftarBarang = snapshot.data!;
          if (daftarBarang.isEmpty) {
            return emptyWidget();
          }

          return layout(daftarBarang);
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }

  SafeArea layout(List<Barang> daftarBarang) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(daftarBarang[index].nama),
                  subtitle: Text(daftarBarang[index].deskripsi),
                  trailing: popupMenu(),
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

  PopupMenuButton<ActionItem> popupMenu() {
    return PopupMenuButton<ActionItem>(
      initialValue: selectedAction,
      onSelected: (ActionItem item) {
        if (item == ActionItem.actionDelete) {
          log("Delete screen");
        } else {
          log("Edit screen");
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
