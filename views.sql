-- =========================================================
-- OBS Çekirdeği - Görünümler
-- =========================================================
SET search_path = obs, public;

-- 4.1 Transkript görünümü
CREATE OR REPLACE VIEW view_transkript AS
SELECT
    o.ogrenci_no,
    (o.ad || ' ' || o.soyad)             AS ogrenci_ad_soyad,
    d.ders_kodu,
    d.ders_adi,
    d.kredi,
    k.yil,
    dn.donem_adi,
    k.vize_notu,
    k.final_notu,
    fn_ortalama_hesapla(k.vize_notu, k.final_notu)   AS ortalama,
    fn_harf_notu_hesapla(k.vize_notu, k.final_notu)  AS harf_notu,
    fn_ders_gecme_durumu(k.vize_notu, k.final_notu)  AS gecme_durumu
FROM ogrenci_dersleri k
JOIN ogrenciler o ON o.ogrenci_id = k.ogrenci_id
JOIN dersler    d ON d.ders_id    = k.ders_id
JOIN donemler  dn ON dn.donem_kodu= k.donem_kodu;

-- 4.2 Bölüm ders listesi
CREATE OR REPLACE VIEW view_bolum_ders_listesi AS
SELECT
    b.bolum_adi,
    d.ders_kodu,
    d.ders_adi,
    d.kredi,
    (og.ad || ' ' || og.soyad) AS ogretmen_ad_soyad
FROM dersler d
JOIN bolumler b   ON b.bolum_id = d.bolum_id
LEFT JOIN ogretmenler og ON og.ogretmen_id = d.ogretmen_id;
