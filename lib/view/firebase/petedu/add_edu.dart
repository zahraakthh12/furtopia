import 'package:furtopia/model/firebase/education_firebase_model.dart';

class AddEducationFirebase {
  static List<PetEducationModel> educationList = [
    // 1. GROOMING PET
    PetEducationModel(
      id: "1",
      title:
          "Grooming Pet: Perawatan Penting untuk Kesehatan dan Kenyamanan Hewan Peliharaan",
      image: [
        "https://drive.google.com/uc?export=view&id=1sBW8X2skyaa1vdgcqb5f20-X3NpK9ke-",
      ],
      content: """
Grooming pet adalah proses perawatan yang dilakukan pada hewan peliharaan untuk menjaga kebersihan, kesehatan, serta penampilan mereka. Grooming mencakup berbagai tahapan penting seperti mandi, menyisir bulu, memotong kuku, membersihkan telinga, dan pengecekan kesehatan kulit.

Apa itu Grooming?
• Memandikan hewan dengan sampo khusus.
• Menyisir dan mengeringkan bulu.
• Memotong kuku.
• Membersihkan telinga & mata.
• Mengecek kondisi kulit & bulu.

Manfaat Grooming:
1. Menjaga kebersihan dan kesehatan.
2. Mencegah penyakit kulit.
3. Deteksi masalah kesehatan lebih awal.
4. Membuat hewan lebih nyaman.
5. Memperkuat bonding dengan pemilik.

Tips Grooming di Rumah:
• Gunakan alat aman.
• Air mandi harus hangat.
• Jangan pakai sampo manusia.
• Grooming pelan agar hewan tidak stres.
• Berikan reward setelah grooming.

Kapan ke Groomer Profesional?
Jika bulu hewan panjang, mudah kusut, atau menunjukkan ketidaknyamanan.
""",
    ),

    // 2. STERILISASI HEWAN
    PetEducationModel(
      id: "2",
      title:
          "Sterilisasi Hewan Peliharaan: Manfaat, Prosedur, dan Pentingnya untuk Kesehatan Pet",
      image: [
        "https://drive.google.com/uc?export=view&id=1y0eFZ2YimJj1Gx26slxDyhWA0UJbe0m_",
      ],
      content: """
Sterilisasi adalah prosedur medis untuk mencegah hewan berkembang biak. Steril sangat dianjurkan untuk menjaga populasi hewan serta kesehatan mereka.

Manfaat Sterilisasi:
• Mengurangi risiko kanker reproduksi.
• Mencegah kehamilan tidak diinginkan.
• Mengurangi agresivitas & perilaku tidak nyaman.
• Membantu kontrol populasi hewan.

Prosedur Steril:
• Pemeriksaan kesehatan terlebih dahulu.
• Tindakan pembedahan singkat.
• Masa pemulihan biasanya 7–14 hari.

Setelah Sterilisasi:
• Hewan butuh tempat tenang.
• Berikan makanan ringan.
• Hindari hewan menjilat luka.
""",
    ),

    // 3. VAKSINASI HEWAN
    PetEducationModel(
      id: "3",
      title:
          "Vaksinasi Hewan Peliharaan: Perlindungan Penting untuk Kehidupan yang Lebih Sehat",
      image: [
        "https://drive.google.com/uc?export=view&id=1Wp2mYXHLJy3P2JIJ1pPU0HMws_Iye1hF",
      ],
      content: """
Vaksinasi melindungi hewan dari berbagai penyakit berbahaya seperti rabies, parvo, dan distemper.

Kenapa Vaksin Penting?
• Mencegah penyakit mematikan.
• Membantu sistem imun berkembang.
• Melindungi hewan & keluarga.

Jadwal Vaksin:
• Anak kucing/anjing: usia 6–8 minggu.
• Booster tiap tahun.
• Vaksin rabies 1 tahun sekali.

Tanda Hewan Perlu Vaksin:
• Aktif, sehat, dan tidak demam.
• Nafsu makan normal.
""",
    ),
  ];
}
