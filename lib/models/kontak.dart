// Model untuk data kontak Firestore
class Kontak {
  String id;
  String nama;
  String email;
  String noHandphone;
  String? kategori;

  Kontak({
    this.id = '',
    required this.nama,
    required this.email,
    required this.noHandphone,
    this.kategori,
  });

  String get inisial => nama.isNotEmpty ? nama[0].toUpperCase() : '?';

  // Kompatibilitas dengan kode sebelumnya
  String get noHp => noHandphone;
  String get inisialNamaDepan => inisial;
}

