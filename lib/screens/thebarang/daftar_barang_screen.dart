import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:open_sisfo_laundry/helpers/widgets.dart';
import 'package:open_sisfo_laundry/models/Barang.dart';
import 'package:open_sisfo_laundry/repositories/barang_repository.dart';

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

  @override
  void initState() {
    super.initState();
    futureDaftarBarang = BarangRepository.reads();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: futureBuilder(),
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
