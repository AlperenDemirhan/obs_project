-- =========================================================
-- OBS Çekirdeği - İş Mantığı
-- =========================================================
SET search_path = obs, public;

-- 3.1 Ağırlıklı ortalama (0.4 vize + 0.6 final)
CREATE OR REPLACE FUNCTION fn_ortalama_hesapla(
    p_vize  NUMERIC,
    p_final NUMERIC
) RETURNS NUMERIC AS
$$
BEGIN
    IF p_vize IS NULL OR p_final IS NULL THEN
        RETURN NULL;
    END IF;
    RETURN ROUND(p_vize*0.4 + p_final*0.6, 2);
END;
$$ LANGUAGE plpgsql;

-- 3.2 Harf notu: doğrudan vize/final alıp harf döndürür
CREATE OR REPLACE FUNCTION fn_harf_notu_hesapla(
    p_vize  NUMERIC,
    p_final NUMERIC
) RETURNS VARCHAR AS
$$
DECLARE
    v_avg NUMERIC;
    v_harf VARCHAR(2);
BEGIN
    v_avg := fn_ortalama_hesapla(p_vize, p_final);
    IF v_avg IS NULL THEN
        RETURN NULL;
    END IF;

    SELECT harf_notu INTO v_harf
    FROM not_esikleri
    WHERE v_avg >= min_puan AND v_avg < max_puan
    ORDER BY min_puan DESC
    LIMIT 1;

    RETURN COALESCE(v_harf, 'FF');
END;
$$ LANGUAGE plpgsql;

-- 3.3 Geçme durumu kuralı: final >=45 ve ortalama >=50
CREATE OR REPLACE FUNCTION fn_ders_gecme_durumu(
    p_vize  NUMERIC,
    p_final NUMERIC
) RETURNS VARCHAR AS
$$
DECLARE
    v_avg NUMERIC;
BEGIN
    IF p_final IS NULL THEN
        RETURN 'Eksik';
    END IF;

    v_avg := fn_ortalama_hesapla(p_vize, p_final);
    IF p_final < 45 THEN
        RETURN 'Kaldı (Final < 45)';
    ELSIF v_avg < 50 THEN
        RETURN 'Kaldı (Ortalama < 50)';
    ELSE
        RETURN 'Geçti';
    END IF;
END;
$$ LANGUAGE plpgsql;

-- 3.4 Prosedür: derse kayıt
CREATE OR REPLACE PROCEDURE sp_ogrenci_derse_kayit(
    p_ogrenci_id BIGINT,
    p_ders_id    BIGINT,
    p_yil        SMALLINT,
    p_donem_kodu SMALLINT
)
LANGUAGE plpgsql
AS
$$
BEGIN
    IF EXISTS (
        SELECT 1 FROM ogrenci_dersleri
        WHERE ogrenci_id = p_ogrenci_id
          AND ders_id    = p_ders_id
          AND yil        = p_yil
          AND donem_kodu = p_donem_kodu
    ) THEN
        RAISE EXCEPTION 'Öğrenci % zaten ders % için %/% döneminde kayıtlı.',
            p_ogrenci_id, p_ders_id, p_yil, p_donem_kodu;
    END IF;

    INSERT INTO ogrenci_dersleri(ogrenci_id, ders_id, yil, donem_kodu)
    VALUES (p_ogrenci_id, p_ders_id, p_yil, p_donem_kodu);

    RAISE NOTICE 'Kayıt başarılı: öğrenci % → ders % (%/%).',
        p_ogrenci_id, p_ders_id, p_yil, p_donem_kodu;
END;
$$;

-- 3.5 Prosedür: not girişi / güncelleme
CREATE OR REPLACE PROCEDURE sp_not_girisi(
    p_kayit_id  BIGINT,
    p_vize      NUMERIC,
    p_final     NUMERIC
)
LANGUAGE plpgsql
AS
$$
BEGIN
    IF p_vize  < 0 OR p_vize  > 100 OR
       p_final < 0 OR p_final > 100 THEN
        RAISE EXCEPTION 'Notlar 0 ile 100 arasında olmalıdır.';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM ogrenci_dersleri WHERE kayit_id = p_kayit_id) THEN
        RAISE EXCEPTION 'Kayıt % bulunamadı.', p_kayit_id;
    END IF;

    UPDATE ogrenci_dersleri
    SET vize_notu = p_vize,
        final_notu = p_final
    WHERE kayit_id = p_kayit_id;

    RAISE NOTICE 'Not güncellendi: kayıt %.', p_kayit_id;
END;
$$;

-- 3.6 Yardımcı: tek kayıt için özet
CREATE OR REPLACE FUNCTION fn_not_ozet(
    p_kayit_id BIGINT
) RETURNS TABLE(
    ogrenci_ad_soyad VARCHAR,
    ders_kodu        VARCHAR,
    ortalama         NUMERIC,
    harf_notu        VARCHAR,
    gecme_durumu     VARCHAR
) AS
$$
BEGIN
    RETURN QUERY
    SELECT
        o.ad || ' ' || o.soyad AS ogrenci_ad_soyad,
        d.ders_kodu,
        fn_ortalama_hesapla(k.vize_notu, k.final_notu) AS ortalama,
        fn_harf_notu_hesapla(k.vize_notu, k.final_notu) AS harf_notu,
        fn_ders_gecme_durumu(k.vize_notu, k.final_notu) AS gecme_durumu
    FROM ogrenci_dersleri k
    JOIN ogrenciler o ON o.ogrenci_id = k.ogrenci_id
    JOIN dersler d    ON d.ders_id    = k.ders_id
    WHERE k.kayit_id = p_kayit_id;
END;
$$ LANGUAGE plpgsql;
