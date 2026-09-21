import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/kontak.dart';

// Halaman Tambah & Edit Kontak
// Berisi form (Nama Lengkap, Email, No. Handphone, Kategori) dan tombol Simpan.
// Menyimpan data kontak langsung ke database Cloud Firestore.
class TambahKontakPage extends StatefulWidget {
  final Kontak? kontak;

  const TambahKontakPage({
    super.key,
    this.kontak,
  });

  @override
  State<TambahKontakPage> createState() => _TambahKontakPageState();
}

class _TambahKontakPageState extends State<TambahKontakPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _noHandphoneController = TextEditingController();
  final TextEditingController _kategoriController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.kontak != null) {
      _namaController.text = widget.kontak!.nama;
      _emailController.text = widget.kontak!.email;
      _noHandphoneController.text = widget.kontak!.noHandphone;
      _kategoriController.text = widget.kontak!.kategori ?? '';
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _noHandphoneController.dispose();
    _kategoriController.dispose();
    super.dispose();
  }

  // FUNGSI SIMPAN KONTAK KE DATABASE FIRESTORE
  Future<void> _simpanKontak() async {
    try {
      if (widget.kontak != null && widget.kontak!.id.isNotEmpty) {
        // Mode edit kontak yang sudah ada
        await FirebaseFirestore.instance
            .collection('kontak')
            .doc(widget.kontak!.id)
            .update({
          'nama': _namaController.text,
          'email': _emailController.text,
          'noHandphone': _noHandphoneController.text,
          'kategori': _kategoriController.text.isEmpty
              ? null
              : _kategoriController.text,
        });
      } else {
        // Mode tambah kontak baru ke Firestore
        await FirebaseFirestore.instance.collection('kontak').add({
          'nama': _namaController.text,
          'email': _emailController.text,
          'noHandphone': _noHandphoneController.text,
          'kategori': _kategoriController.text.isEmpty
              ? null
              : _kategoriController.text,
        });
      }

      // Bersihkan form
      _namaController.clear();
      _emailController.clear();
      _noHandphoneController.clear();
      _kategoriController.clear();

      if (!mounted) return;

      // Tampilkan SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data berhasil disimpan'),
          duration: Duration(seconds: 2),
        ),
      );

      // Otomatis kembali ke halaman utama
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan kontak: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.kontak != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Kontak' : 'Tambah Kontak'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Email tidak boleh kosong';
                  }
                  if (!value.contains('@')) {
                    return 'Email harus mengandung karakter @';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _noHandphoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'No. Handphone',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nomor handphone tidak boleh kosong';
                  }
                  if (!RegExp(r'^\d+$').hasMatch(value.trim())) {
                    return 'Nomor handphone hanya boleh berisi angka';
                  }
                  if (value.trim().length < 10) {
                    return 'Nomor handphone minimal 10 digit';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _kategoriController,
                decoration: const InputDecoration(
                  labelText: 'Kategori (opsional)',
                  hintText: 'Contoh: Keluarga, Teman, atau Kerja',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _simpanKontak();
                  }
                },
                icon: const Icon(Icons.save),
                label: Text(isEdit ? 'Simpan Perubahan' : 'Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
