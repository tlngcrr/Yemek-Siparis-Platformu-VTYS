-- GÖRÜNÜMLER (VIEWS)
-- Aktif menüyü fiyatlarıyla listeler
GO
CREATE VIEW vw_AktifMenuListesi AS
SELECT R.RestoranAd, U.UrunAd, U.Fiyat
FROM Restoranlar R
INNER JOIN Urunler U ON R.RestoranID = U.RestoranID
WHERE R.IsActive = 1 AND U.IsActive = 1;
GO

-- Havuzun o anki toplam bakiyesini gösterir
CREATE VIEW vw_AskidaHavuzOzet AS
SELECT ToplamBakiye, SonGuncelleme
FROM AskidaYemekHavuzu;
GO

-- İNDEKSLER (INDEX)
-- Kullanıcı girişlerini ve arama hızını artırır
CREATE INDEX IDX_KullaniciEposta ON Kullanicilar(Eposta);
CREATE INDEX IDX_RestoranAd ON Restoranlar(RestoranAd);