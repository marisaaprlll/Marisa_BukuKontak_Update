import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/kontak.dart';
import 'tambah_kontak_page.dart';

// Halaman Kontak
// Menampilkan daftar kontak dari Cloud Firestore secara realtime (StreamBuilder).
// Dilengkapi fitur pencarian berdasarkan nama dan kategori, serta edit dan hapus.
class KontakPage extends StatefulWidget {
  const KontakPage({super.key});

  @override
  State<KontakPage> createState() => _KontakPageState();
}

class _KontakPageState extends State<KontakPage> {
  final StreamController<String> _searchController =
      StreamController<String>.broadcast();
  final TextEditingController _pencarianController = TextEditingController();

  @override
  void dispose() {
    _searchController.close();
    _pencarianController.dispose();
    super.dispose();
  }

  // Buka halaman edit kontak
  Future<void> _editKontak(Kontak kontak) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TambahKontakPage(kontak: kontak),
      ),
    );
  }

  // Hapus kontak dari database Cloud Firestore
  Future<void> _hapusKontak(Kontak kontak) async {
    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Kontak'),
          content: Text(
            'Apakah Anda yakin ingin menghapus kontak ${kontak.nama}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (konfirmasi == true && kontak.id.isNotEmpty) {
      try {
        await FirebaseFirestore.instance
            .collection('kontak')
            .doc(kontak.id)
            .delete();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Kontak berhasil dihapus'),
            duration: Duration(seconds: 2),
          ),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menghapus kontak: $e')),
        );
      }
    }
  }

  // Widget tampilan daftar kontak
  Widget daftarKontak(List<Kontak> daftar) {
    if (daftar.isEmpty) {
      return const Center(
        child: Text(
          'Belum ada kontak',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 6),
      itemCount: daftar.length,
      itemBuilder: (context, index) {
        final kontak = daftar[index];
        return Card(
          margin: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          elevation: 2,
          child: ListTile(
            leading: CircleAvatar(
              child: Text(kontak.inisial),
            ),
            title: Text(kontak.nama),
            subtitle: Text(
              '${kontak.email}\n'
              '${kontak.noHandphone}\n'
              '${kontak.kategori ?? "Tanpa kategori"}',
            ),
            isThreeLine: true,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  tooltip: 'Edit Kontak',
                  onPressed: () => _editKontak(kontak),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  tooltip: 'Hapus Kontak',
                  onPressed: () => _hapusKontak(kontak),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Text field pencarian kontak
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextField(
            controller: _pencarianController,
            onChanged: (teks) {
              _searchController.add(teks);
            },
            decoration: const InputDecoration(
              labelText: 'Cari kontak...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
        ),

        // StreamBuilder Firestore & Pencarian sesuai Bagian F.2 Modul
        Expanded(
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('kontak')
                .snapshots(),
            builder: (context, snapshot) {
              // Loading
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              // Error
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Terjadi kesalahan: ${snapshot.error}',
                  ),
                );
              }

              // Stream pencarian
              return StreamBuilder<String>(
                stream: _searchController.stream,
                initialData: '',
                builder: (context, searchSnapshot) {
                  final keyword =
                      (searchSnapshot.data ?? '').toLowerCase();

                  // Ambil data Firestore
                  final daftarKontakFirestore =
                      snapshot.data!.docs.map((doc) {
                    final data = doc.data();

                    return Kontak(
                      id: doc.id,
                      nama: data['nama'] ?? '',
                      email: data['email'] ?? '',
                      noHandphone: data['noHandphone'] ?? '',
                      kategori: data['kategori'],
                    );
                  }).toList();

                  // Filter
                  final hasilFilter =
                      daftarKontakFirestore.where((kontak) {
                    final nama = kontak.nama.toLowerCase();
                    final kategori =
                        (kontak.kategori ?? '').toLowerCase();

                    return nama.contains(keyword) ||
                        kategori.contains(keyword);
                  }).toList();

                  return daftarKontak(hasilFilter);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
