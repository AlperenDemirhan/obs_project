-- =========================================================
-- OBS Çekirdeği - Örnek Veri
-- =========================================================
SET search_path = obs, public;

-- Bölümler
INSERT INTO bolumler (bolum_kodu, bolum_adi) VALUES
('CENG','Bilgisayar Mühendisliği'),
('MATH','Matematik'),
('PHYS','Fizik'),
('EE',  'Elektrik Mühendisliği');

-- Öğretmenler
INSERT INTO ogretmenler (ad, soyad, eposta, bolum_id) VALUES
('Ahmet','Yılmaz','ahmet.yilmaz@uni.edu', 1),
('Selin','Demir', 'selin.demir@uni.edu',  1),
('Hasan','Aydın', 'hasan.aydin@uni.edu',  2),
('Ebru', 'Şahin', 'ebru.sahin@uni.edu',   3),
('John', 'Smith', 'john.smith@uni.edu',   4);

-- Öğrenciler
INSERT INTO ogrenciler (ogrenci_no, ad, soyad, eposta, baslangic_yili, bolum_id) VALUES
('20240001','Ali',   'Kaya',   'ali.kaya@ogr.uni.edu', 2024, 1),
('20240002','Ayşe',  'Koç',    'ayse.koc@ogr.uni.edu', 2024, 1),
('20240003','Mehmet','Can',    'mehmet.can@ogr.uni.edu', 2023, 2),
('20240004','Zeynep','Yıldız', 'zeynep.yildiz@ogr.uni.edu', 2022, 3),
('20240005','Fatma', 'Eren',   'fatma.eren@ogr.uni.edu', 2024, 4);

-- Dersler
INSERT INTO dersler (ders_kodu, ders_adi, kredi, bolum_id, ogretmen_id) VALUES
('CENG101', 'Programlamaya Giriş', 4, 1, 1),
('CENG201', 'Veritabanı Sistemleri', 3, 1, 2),
('MATH101', 'Calculus I', 4, 2, 3),
('PHYS101', 'Genel Fizik I', 4, 3, 4),
('EE101',   'Devre Analizi', 3, 4, 5);

-- Harf notu eşikleri
INSERT INTO not_esikleri (harf_notu, min_puan, max_puan) VALUES
('AA', 90, 100),
('BA', 85, 90),
('BB', 75, 85),
('CB', 65, 75),
('CC', 55, 65),
('DC', 50, 55),
('DD', 45, 50),
('FF',  0, 45);

-- Kayıtlar + Notlar
-- Ali Kaya
INSERT INTO ogrenci_dersleri (ogrenci_id, ders_id, yil, donem_kodu, vize_notu, final_notu) VALUES
(1, 1, 2024, 1, 75, 80),
(1, 2, 2024, 1, 65, 70),
(1, 3, 2024, 1, 55, 50);

-- Ayşe Koç
INSERT INTO ogrenci_dersleri (ogrenci_id, ders_id, yil, donem_kodu, vize_notu, final_notu) VALUES
(2, 1, 2024, 1, 85, 90),
(2, 2, 2024, 1, 70, 65);

-- Mehmet Can
INSERT INTO ogrenci_dersleri (ogrenci_id, ders_id, yil, donem_kodu, vize_notu, final_notu) VALUES
(3, 3, 2023, 1, 50, 60),
(3, 4, 2023, 2, 45, 55);

-- Zeynep Yıldız
INSERT INTO ogrenci_dersleri (ogrenci_id, ders_id, yil, donem_kodu, vize_notu, final_notu) VALUES
(4, 4, 2024, 2, 60, 65),
(4, 1, 2024, 2, 75, 70);

-- Fatma Eren
INSERT INTO ogrenci_dersleri (ogrenci_id, ders_id, yil, donem_kodu, vize_notu, final_notu) VALUES
(5, 5, 2024, 1, 90, 95),
(5, 2, 2024, 2, 55, 60);
