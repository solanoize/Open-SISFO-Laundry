import 'package:flutter/material.dart';
import 'package:open_sisfo_laundry/helpers/widgets.dart';
import 'package:open_sisfo_laundry/screens/thebarang/daftar_barang_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    DaftarBarangScreen(),
  ];

  final menuItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Barang',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.shopping_basket_outlined),
      label: 'Terima',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.dry_cleaning_outlined),
      label: 'Selesai',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.get_app_outlined),
      label: 'Ambil',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.article_outlined),
      label: 'Laporan',
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(context: context, title: "Laundry"),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: [...menuItems],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor:
            Theme.of(context).colorScheme.secondary.withOpacity(0.6),
        showUnselectedLabels: true,
        onTap: _onItemTapped,
      ),
    );
  }
}
