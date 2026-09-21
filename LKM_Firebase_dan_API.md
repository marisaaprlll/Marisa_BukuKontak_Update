# LEMBAR KERJA MURID (LKM)
## Firebase dan API

**Mata Pelajaran:** Pemrograman Perangkat Bergerak  
**Nama:** Marisa Aprilya Hapsari  
**Kelas:** XII RPL B  
**Tanggal:** 21 September 2026  

---

### A. Tujuan Pembelajaran
Setelah mengerjakan LKM ini, kamu mampu:
1. Menjelaskan perbedaan backend tradisional dan Backend-as-a-Service (BaaS), serta peran API, format JSON, dan Cloud Firestore.
2. Menghubungkan proyek Flutter Buku Kontak dengan Firebase dan Cloud Firestore.
3. Menyimpan data kontak ke Firestore sehingga data tidak hilang ketika aplikasi ditutup.
4. Menampilkan data kontak dari Firestore pada TabBarView menggunakan StreamBuilder.
5. Mengubah fungsi edit dan hapus secara mandiri agar data di database ikut berubah.
6. Mengunggah hasil pekerjaan ke GitHub dengan pesan commit.

---

### B. Ketentuan Pengerjaan
1. Satu kelompok terdiri dari 3–4 murid dan memakai satu laptop bersama.
2. Semua anggota wajib memahami hasil kelompok. Guru dapat meminta siapa saja menjelaskan atau mendemonstrasikan pekerjaan kelompok.
3. Jika muncul error: (1) baca pesan errornya, (2) diskusikan dalam kelompok, (3) tanya kelompok lain. Catat pesan error pada kolom catatan.
4. Pertanyaan dikerjakan secara individu.

---

### C. Memahami Konsep
**Bandingkan backend tradisional dengan Backend-as-a-Service (Firebase):**

| Aspek | Backend tradisional (server sendiri) | BaaS (Firebase) |
| :--- | :--- | :--- |
| **Penyiapan server** | Harus sewa VPS/hosting, pasang OS (Linux), install web server (Apache/Nginx), database (MySQL), dan konfigurasi manual dari awal. | Langsung siap pakai (*zero-setup*), infrastruktur backend sudah disediakan oleh penyedia layanan (Google). |
| **Pemeliharaan dan keamanan server** | Pengembang bertanggung jawab penuh melakukan update OS, patching keamanan, backup rutin, dan monitoring server (*maintenance* tinggi). | Sepenuhnya dikelola oleh Google (*zero-maintenance*), keamanan fisik & server ditangani otomatis. |
| **Saat pengguna bertambah banyak** | Harus melakukan scaling manual (upgrade RAM/CPU atau menambah server load balancer), rawan *down* jika trafik melonjak drastis. | *Auto-scaling* otomatis, mampu menangani lonjakan dari puluhan hingga jutaan pengguna secara instan tanpa perlu setting server. |
| **Fokus pekerjaan pengembang** | Terbagi antara memikirkan logic backend, database, infrastruktur server, dan tampilan frontend. | Pengembang hanya perlu fokus pada kode aplikasi di sisi klien (frontend UI/UX) dan memanggil layanan melalui SDK/API. |

---

### D. Bandingkan Dua Cara Membaca Data dari Firestore

| Aspek | One-time Read (`get()` / `Future`) | Realtime Listener (`snapshots()` / `Stream`) |
| :--- | :--- | :--- |
| **Cara kerja koneksi** | Menggunakan standar Request-Response: aplikasi meminta data, server mengirim, lalu koneksi langsung ditutup. | Membuka koneksi persisten (*persistent connection/WebSocket*). Server akan terus "mendorong" (*push*) data terbaru ke aplikasi. |
| **Jika data di server berubah** | Aplikasi tidak akan tahu ada perubahan sebelum pengguna meminta ulang / merefresh halaman secara manual. | Aplikasi otomatis menerima update data secara instan saat ada aksi Create, Update, atau Delete tanpa perlu refresh. |
| **Cocok dipakai untuk** | Halaman statis, data profil yang jarang berubah, laporan bulanan, atau pencarian sekali jalan. | Aplikasi chat, daftar kontak bersama, dashboard realtime, notifikasi langsung, atau live tracking. |

**Menurutmu, cara mana yang lebih tepat untuk menampilkan daftar kontak di TabBarView? Berikan alasan:**
> **Jawaban:**  
> Cara yang lebih tepat adalah **Realtime Listener (`snapshots()` / `Stream`)**.  
> **Alasannya:** Dengan `snapshots()`, daftar kontak di TabBarView akan langsung sinkron secara otomatis begitu data baru ditambahkan, diedit, atau dihapus (baik dari aplikasi sendiri, aplikasi lain, maupun langsung dari Firebase Console) tanpa mengharuskan pengguna me-restart atau me-refresh aplikasi secara manual.

---

### E. Menghubungkan Proyek ke Firebase

#### Tabel Checklist Langkah:
| No | Langkah | Selesai | Catatan / kendala |
| :---: | :--- | :---: | :--- |
| 1 | Buka console.firebase.google.com, login, lalu klik Create a new Firebase project. | ✓ | Berhasil membuat project `buku-kontak-b8de1`. |
| 2 | Beri nama proyek, klik Continue, nonaktifkan Google Analytics, lalu klik Create project. | ✓ | Project Firebase berhasil di-generate. |
| 3 | Install Firebase CLI dengan npm (`npm install -g firebase-tools`), lalu jalankan firebase login di Terminal/CMD. | ✓ | Berhasil login via browser. |
| 4 | Install dan jalankan FlutterFire CLI (`flutterfire configure`). Pilih proyek Firebase dan platform yang dipakai (Android & Web). | ✓ | Menghasilkan `firebase_options.dart` & `google-services.json`. |
| 5 | Di terminal proyek buku_kontak, jalankan `flutter pub add firebase_core` lalu `flutter pub add cloud_firestore`. | ✓ | Dependency terpasang di `pubspec.yaml`. |
| 6 | Inisialisasi Firebase pada fungsi `main()` di `main.dart`. | ✓ | `WidgetsFlutterBinding.ensureInitialized()` & `Firebase.initializeApp()` berhasil dipasang. |
| 7 | Di Firebase Console pilih Build ➜ Firestore Database ➜ Create database ➜ Standard edition, pilih lokasi, lalu pilih Start in test mode. | ✓ | Database Firestore aktif dalam mode uji coba (*test mode*). |
| 8 | Bukti: buka Project settings ➜ General, pastikan aplikasi Flutter kelompok muncul pada daftar apps. | ✓ | Aplikasi `kontak_form` (`com.example.kontak_form`) terdaftar. |

#### Jelaskan fungsi setiap komponen berikut dengan kata-katamu sendiri:
- **Firebase CLI:** Alat berbasis baris perintah (terminal) dari Google untuk mengelola, login, dan mengonfigurasi layanan Firebase langsung dari komputer.
- **FlutterFire CLI:** Alat bantu khusus Flutter untuk mengotomatiskan pendaftaran aplikasi ke Firebase dan menghasilkan file konfigurasi `firebase_options.dart`.
- **Package `firebase_core`:** Plugin inti Flutter yang wajib diinstal untuk menginisialisasi koneksi awal antara aplikasi Flutter dengan layanan Firebase.
- **Package `cloud_firestore`:** Plugin Flutter resmi untuk membaca, menulis, memperbarui, dan mendengarkan data realtime dari database NoSQL Cloud Firestore.
- **File `firebase_options.dart`:** File Dart otomatis yang menyimpan kredensial API key, Project ID, App ID, dan metadata Firebase untuk setiap platform (Android, iOS, Web).
- **Start in test mode:** Pengaturan aturan keamanan (*security rules*) awal Firestore yang mengizinkan semua operasi baca (*read*) dan tulis (*write*) secara terbuka selama 30 hari untuk keperluan pengujian/pengembangan.

---

### F. Menyimpan Kontak ke Firestore

#### Tabel Checklist:
| No | Langkah | Selesai | Catatan / kendala |
| :---: | :--- | :---: | :--- |
| 1 | Tambahkan import Firestore di bagian atas file dart Buku Kontak: `import 'package:cloud_firestore/cloud_firestore.dart';` | ✓ | Berhasil di-import pada `tambah_kontak_page.dart`. |
| 2 | Hapus fungsi simpanKontak() yang lama, lalu ganti dengan fungsi simpanKontak() yang baru dari modul. | ✓ | Menggunakan `FirebaseFirestore.instance.collection('kontak').add(...)`. |
| 3 | Jalankan aplikasi, lalu tambahkan minimal 3 kontak yang berbeda. | ✓ | Input nama, email, no handphone, dan kategori berhasil. |
| 4 | Pastikan SnackBar “Data berhasil disimpan” muncul, lalu cek di Firebase Console (Firestore Database) apakah datanya masuk. | ✓ | Dokumen baru masuk ke collection `kontak` di console. |

**Mengapa proses menyimpan data dibungkus dengan try–catch? Apa yang tampil di layar jika penyimpanan gagal?**
> **Jawaban:**  
> Proses penyimpanan data dibungkus dengan `try-catch` karena operasi ke database Cloud melibatkan jaringan internet (*asynchronous*) yang rentan terjadi kendala (misal: koneksi terputus, database belum dibuat, atau izin ditolak/permission-denied). Blok `try-catch` mencegah aplikasi mengalami *crash* (layar merah/force close) ketika terjadi galat.  
> **Yang tampil di layar jika gagal:** Aplikasi akan menangkap error di blok `catch` lalu memunculkan notifikasi `SnackBar` merah di bagian bawah layar bertuliskan: *"Gagal menyimpan kontak: [pesan error]"*.

---

### G. Menampilkan Data pada TabBarView dan Menguji Data Permanen

#### Tabel Checklist:
| No | Langkah | Selesai | Catatan / kendala |
| :---: | :--- | :---: | :--- |
| 1 | Tambahkan properti id pada class Kontak (`String id;` dan `this.id = ''` pada constructor) sesuai modul. | ✓ | Berhasil ditambahkan di `lib/models/kontak.dart`. |
| 2 | Tambahkan kode StreamBuilder dari modul pada TabBarView agar data kontak dari Firestore tampil. | ✓ | Berhasil dipasang di `lib/pages/kontak_page.dart`. |
| 3 | Jalankan aplikasi dan pastikan kontak yang tadi kamu simpan tampil di TabBarView. | ✓ | Data tampil secara realtime. |

#### Uji Data Permanen:
| No | Skenario uji | Prediksi | Hasil sebenarnya |
| :---: | :--- | :--- | :--- |
| 1 | Tambah kontak baru lewat form di aplikasi | Kontak akan langsung tersimpan di cloud dan otomatis muncul di daftar TabBarView. | Kontak langsung muncul di list kartu kontak dan dokumen bertambah di Firebase Console. |
| 2 | Tutup aplikasi sepenuhnya, lalu buka lagi | Data kontak tidak akan hilang karena tersimpan di server cloud Firestore. | Data kontak tetap ada dan langsung dimuat kembali secara utuh saat aplikasi dibuka. |
| 3 | Ubah isi field nama langsung di Firebase Console, tanpa menyentuh aplikasi | Nama kontak pada layar HP/aplikasi akan langsung berubah otomatis secara realtime. | Nama di aplikasi langsung ter-update seketika tanpa perlu menekan tombol refresh apa pun. |
| 4 | Ketik kata kunci pada kolom pencarian kontak | Daftar kontak akan tersaring dan hanya menampilkan nama/kategori yang cocok. | List kontak langsung terfilter sesuai keyword pencarian secara instan. |

**Apa fungsi CircularProgressIndicator pada kode StreamBuilder, dan pada kondisi apa ia tampil?**
> **Jawaban:**  
> `CircularProgressIndicator` berfungsi sebagai indikator pemuatan (*loading indicator*) animasi berputar untuk memberi tahu pengguna bahwa aplikasi sedang aktif mengambil/mengunduh data dari server Firebase di awan.  
> **Kondisi tampilnya:** Tampil pada saat `snapshot.connectionState == ConnectionState.waiting`, yaitu saat koneksi ke Firestore pertama kali dibuka dan data awal belum selesai diterima oleh aplikasi.

---

### H. Mandiri: Memperbaiki Fungsi Edit dan Hapus

#### Implementasi dan Pengujian: Hapus
| No | Kriteria keberhasilan | Berhasil (✓ / ✗) | Catatan |
| :---: | :--- | :---: | :--- |
| 1 | Kontak yang dipilih terhapus dari daftar di aplikasi (bukan kontak lain). | ✓ | Menggunakan `doc(kontak.id).delete()`. |
| 2 | Dokumen kontak tersebut hilang dari Firebase Console. | ✓ | Dokumen terhapus permanen dari collection `kontak`. |
| 3 | Daftar langsung diperbarui tanpa restart atau refresh manual. | ✓ | Berkat `snapshots()` StreamBuilder, item langsung lenyap dari layar. |
| 4 | Setelah aplikasi ditutup dan dibuka lagi, kontak tetap terhapus. | ✓ | Terverifikasi permanen di cloud. |
| 5 | SnackBar berhasil atau gagal tampil (memakai try–catch). | ✓ | Muncul SnackBar "Kontak berhasil dihapus". |
| 6 | Fitur tambah kontak dan pencarian kontak tetap berfungsi. | ✓ | Seluruh fitur tetap berjalan normal. |

#### Implementasi dan Pengujian: Edit
| No | Kriteria keberhasilan | Berhasil (✓ / ✗) | Catatan |
| :---: | :--- | :---: | :--- |
| 1 | Form edit menampilkan data lama dari kontak yang dipilih. | ✓ | Controller form otomatis terisi dari data objek `kontak`. |
| 2 | Setelah disimpan, data baru tampil pada daftar kontak. | ✓ | Data ter-update secara otomatis di list. |
| 3 | Dokumen yang sama di Firebase Console ikut berubah (ID sama, jumlah dokumen tidak bertambah). | ✓ | Menggunakan `.doc(kontak.id).update(...)` sehingga ID tetap sama. |
| 4 | Tidak muncul kontak ganda setelah edit. | ✓ | Tidak ada duplikasi dokumen baru. |
| 5 | Setelah aplikasi ditutup dan dibuka lagi, hasil edit tetap ada. | ✓ | Perubahan tersimpan permanen di cloud database. |
| 6 | SnackBar berhasil atau gagal tampil (memakai try–catch). | ✓ | Menampilkan SnackBar "Data berhasil disimpan". |

---

### I. Pertanyaan Kesimpulan

**1. Jelaskan perbedaan penyimpanan data kontak sebelum dan sesudah memakai Firestore. Mengapa sekarang data tidak hilang ketika aplikasi ditutup?**
> **Jawaban:**  
> Sebelum menggunakan Firestore, data kontak hanya disimpan pada memori sementara aplikasi (variabel `List<Kontak>` di RAM lokal). Akibatnya, begitu aplikasi ditutup (*kill app*), memori RAM dibersihkan dan seluruh data hilang (*volatile*).  
> Sesudah menggunakan Firestore, setiap data kontak langsung dikirim melalui internet dan disimpan secara permanen di database awan (*cloud storage*) milik Google Firebase. Saat aplikasi ditutup lalu dibuka kembali, aplikasi akan melakukan *fetch* data dari Firestore, sehingga data tidak akan pernah hilang.

**2. Apa perbedaan One-time Read (`get()`) dan Realtime Listener (`snapshots()`)? Mana yang dipakai pada TabBarView kontak, dan apa keuntungannya bagi pengguna?**
> **Jawaban:**  
> - `get()` hanya mengambil data satu kali saat fungsi dipanggil lalu memutus aliran data.
> - `snapshots()` menjaga koneksi stream tetap terbuka dan aktif mendengarkan setiap event perubahan data di database.  
> **Yang dipakai pada TabBarView:** `snapshots()`.  
> **Keuntungannya bagi pengguna:** Pengalaman pengguna (*user experience*) menjadi jauh lebih cepat dan responsif. Pengguna tidak perlu repot menekan tombol refresh atau keluar-masuk menu untuk melihat data kontak yang baru saja ditambah, diubah, atau dihapus oleh siapapun.

**3. Mengapa fungsi edit dan hapus membutuhkan ID dokumen? Apa yang akan terjadi jika ID tersebut tidak ada?**
> **Jawaban:**  
> Firestore menyimpan setiap data sebagai sebuah dokumen unik di dalam *collection*, di mana ID dokumen berfungsi sebagai *primary key* (alamat penunjuk unik) dokumen tersebut. Untuk mengubah (`update`) atau menghapus (`delete`), Firestore harus mengetahui secara spesifik dokumen mana yang dituju melalui `doc(id)`.  
> **Jika ID tersebut tidak ada:** Firestore tidak dapat menentukan dokumen target. Jika dipaksakan menyimpan tanpa ID dokumen tertentu, data justru akan terbuat sebagai dokumen baru (*duplicate entry*), atau operasi update/delete akan gagal (*error*).

**4. Refleksi: bagian mana yang menurutmu paling sulit, dan apa yang kamu pelajari dari bekerja dalam kelompok dengan satu laptop?**
> **Jawaban:**  
> - **Bagian paling menantang:** Memahami alur kerja *asynchronous stream* pada `StreamBuilder` serta menghubungkan CLI tools (`Firebase CLI` dan `FlutterFire`) dari terminal sampai konfigurasi terpasang dengan benar di Android/Web.
> - **Pelajaran yang didapat:** Belajar pentingnya pembagian peran secara terstruktur saat bekerja satu laptop (misal: ada yang membaca alur modul/dokumentasi, ada yang mengetik kode/eksekusi terminal, dan ada yang memeriksa error/log console bersama-sama), serta memahami konsep modern penyimpanan data cloud NoSQL yang umum digunakan di industri perangkat lunak.
