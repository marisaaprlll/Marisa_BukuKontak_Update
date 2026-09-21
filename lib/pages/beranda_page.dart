import 'package:flutter/material.dart';
import 'kontak_page.dart';
import 'favorit_page.dart';
import 'tentang_page.dart';
import 'tambah_kontak_page.dart';

class BerandaPage extends StatefulWidget {
  const BerandaPage({super.key});

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  static const int _tabKontak = 0;
  static const int _tabFavorit = 1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // agar FloatingActionButton ikut update saat tab berpindah
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Membuka Halaman Tambah Kontak
  Future<void> _bukaTambahKontak() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TambahKontakPage()),
    );
  }

  // Membuka Halaman Tentang (profil diri)
  void _bukaTentang() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TentangPage()),
    );
  }

  // Dipanggil dari menu Drawer untuk berpindah tab / halaman
  void _pilihMenuDrawer(int index) {
    Navigator.pop(context); // tutup drawer dulu

    if (index == -1) {
      // -1 menandakan menu "Tambah Kontak" -> buka halaman baru
      _bukaTambahKontak();
    } else if (index == -2) {
      // -2 menandakan menu "Tentang Saya" -> buka halaman baru
      _bukaTentang();
    } else {
      setState(() {
        _tabController.index = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buku Kontak'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const <Widget>[
            Tab(icon: Icon(Icons.contacts), text: 'Kontak'),
            Tab(icon: Icon(Icons.star), text: 'Favorit'),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.indigo),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Icon(Icons.contact_page, color: Colors.white, size: 40),
                  SizedBox(height: 8),
                  Text(
                    'Menu Navigasi',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.contacts),
              title: const Text('Kontak'),
              onTap: () => _pilihMenuDrawer(_tabKontak),
            ),
            ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.person_add),
              ),
              title: const Text('Tambah Kontak'),
              onTap: () => _pilihMenuDrawer(-1),
            ),
            ListTile(
              leading: const Icon(Icons.star),
              title: const Text('Favorit'),
              onTap: () => _pilihMenuDrawer(_tabFavorit),
            ),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('Tentang Saya'),
              onTap: () => _pilihMenuDrawer(-2),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const <Widget>[
          KontakPage(),
          FavoritPage(),
        ],
      ),
      // FloatingActionButton hanya ditampilkan di tab Kontak
      floatingActionButton: _tabController.index == _tabKontak
          ? FloatingActionButton(
              onPressed: _bukaTambahKontak,
              tooltip: 'Tambah Kontak',
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}