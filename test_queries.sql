
SET search_path = obs, public;

-- A) Fonksiyon testleri
SELECT fn_ortalama_hesapla(70, 80)   AS ortalama;        -- 76.00
SELECT fn_harf_notu_hesapla(70, 80)  AS harf_notu;       -- CB/BB aralığına göre
SELECT fn_ders_gecme_durumu(70, 40)  AS durum;           -- Kaldı (Final < 45)


-- Not güncelle
CALL sp_not_girisi(1, 90, 95);


-- C) JOIN & GROUP BY örnekleri
-- Bölüme göre öğrenci sayısı
SELECT b.bolum_adi, COUNT(*) AS ogrenci_sayisi
FROM ogrenciler o
JOIN bolumler b ON b.bolum_id = o.bolum_id
GROUP BY b.bolum_adi
ORDER BY ogrenci_sayisi DESC;

-- Ders bazında ortalama (vize/finalden hesaplanmış)
SELECT d.ders_kodu, d.ders_adi,
       ROUND(AVG(fn_ortalama_hesapla(k.vize_notu, k.final_notu)),2) AS ders_ortalama
FROM ogrenci_dersleri k
JOIN dersler d ON d.ders_id = k.ders_id
GROUP BY d.ders_kodu, d.ders_adi
ORDER BY d.ders_kodu;

-- D) Görünümler
SELECT * FROM view_transkript WHERE ogrenci_no = '20240001';
SELECT * FROM view_bolum_ders_listesi ORDER BY bolum_adi, ders_kodu;
