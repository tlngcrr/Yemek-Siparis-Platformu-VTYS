-- VTYS-1 Dönem Projesi: Çevrimiçi Yemek Sipariş Platformu [cite: 1]
-- Yazar: Tülin Geçer (Bilgisayar Mühendisliği Öğrencisi) [cite: 1, 3]

-- 1. KULLANICILAR TABLOSU [cite: 5]
-- Müşteri, restoran ve kurye verileri burada tutulur.
CREATE TABLE Kullanicilar (
    KullaniciID INT PRIMARY KEY IDENTITY(1,1),
    Ad NVARCHAR(50) NOT NULL,
    Soyad NVARCHAR(50) NOT NULL,
    Eposta NVARCHAR(100) UNIQUE NOT NULL, -- [cite: 16]
    Telefon CHAR(11) CHECK (LEN(Telefon) = 11), -- [cite: 14]
    KullaniciTipi NVARCHAR(20) CHECK (KullaniciTipi IN ('Musteri', 'Restoran', 'Kurye')),
    IsVerified BIT DEFAULT 0, -- İhtiyaç sahibi doğrulaması için [cite: 7]
    IsActive BIT DEFAULT 1 -- Soft Delete (Pasife çekme) [cite: 20]
);

-- 2. RESTORANLAR TABLOSU
CREATE TABLE Restoranlar (
    RestoranID INT PRIMARY KEY IDENTITY(1,1),
    YoneticiID INT FOREIGN KEY REFERENCES Kullanicilar(KullaniciID), -- [cite: 13]
    RestoranAd NVARCHAR(100) NOT NULL,
    Puan FLOAT CHECK (Puan BETWEEN 1 AND 5), -- Zorunlu CHECK [cite: 14, 15]
    IsActive BIT DEFAULT 1 -- [cite: 20]
);

-- 3. ÜRÜNLER TABLOSU (MENÜ) [cite: 5]
CREATE TABLE Urunler (
    UrunID INT PRIMARY KEY IDENTITY(1,1),
    RestoranID INT FOREIGN KEY REFERENCES Restoranlar(RestoranID),
    UrunAd NVARCHAR(100) NOT NULL,
    Fiyat DECIMAL(10,2) CHECK (Fiyat > 0), -- [cite: 14]
    IsActive BIT DEFAULT 1 -- [cite: 20]
);

-- 4. ASKIDA YEMEK HAVUZU (ÖZEL KURAL) [cite: 7]
-- Bağışların toplandığı ana kasa.
CREATE TABLE AskidaYemekHavuzu (
    HavuzID INT PRIMARY KEY IDENTITY(1,1),
    ToplamBakiye DECIMAL(18,2) DEFAULT 0 CHECK (ToplamBakiye >= 0),
    SonGuncelleme DATETIME DEFAULT GETDATE()
);

-- 5. ASKIDA YEMEK İŞLEMLERİ [cite: 8]
-- Bağış yapan hayırseverlerin ve kullanan ihtiyaç sahiplerinin kaydı.
CREATE TABLE AskidaYemekIslemleri (
    IslemID INT PRIMARY KEY IDENTITY(1,1),
    KullaniciID INT FOREIGN KEY REFERENCES Kullanicilar(KullaniciID),
    IslemTipi NVARCHAR(10) CHECK (IslemTipi IN ('Bagis', 'Kullanim')),
    Tutar DECIMAL(10,2) NOT NULL,
    GizliBagis BIT DEFAULT 0, -- Hayırseverin kimliğini gizleme opsiyonu [cite: 7]
    IslemTarihi DATETIME DEFAULT GETDATE()
);
-- 6. SİPARİŞLER TABLOSU
CREATE TABLE Siparisler (
    SiparisID INT PRIMARY KEY IDENTITY(1,1),
    MusteriID INT FOREIGN KEY REFERENCES Kullanicilar(KullaniciID),
    RestoranID INT FOREIGN KEY REFERENCES Restoranlar(RestoranID),
    KuryeID INT FOREIGN KEY REFERENCES Kullanicilar(KullaniciID),
    ToplamTutar DECIMAL(10,2) CHECK (ToplamTutar >= 0), -- [cite: 14]
    SiparisDurumu NVARCHAR(20) CHECK (SiparisDurumu IN ('Hazirlaniyor', 'Yolda', 'Teslim Edildi', 'Iptal')),
    AskidaMi BIT DEFAULT 0, -- Eğer sipariş havuzdan ödendiyse 1 olur
    SiparisTarihi DATETIME DEFAULT GETDATE()
);

-- 7. SİPARİŞ DETAYLARI TABLOSU (Her siparişteki ürünler)
CREATE TABLE SiparisDetaylari (
    DetayID INT PRIMARY KEY IDENTITY(1,1),
    SiparisID INT FOREIGN KEY REFERENCES Siparisler(SiparisID),
    UrunID INT FOREIGN KEY REFERENCES Urunler(UrunID),
    Adet INT CHECK (Adet > 0),
    BirimFiyat DECIMAL(10,2)
);
-- 8. TETİKLEYİCİLER (TRIGGERS) [cite: 29]
-- Askıda Yemek havuzundaki bakiyeyi otomatik güncelleyen trigger
GO
CREATE TRIGGER trg_AskidaBakiyeGuncelle
ON AskidaYemekIslemleri
AFTER INSERT
AS
BEGIN
    DECLARE @Tutar DECIMAL(10,2), @Tip NVARCHAR(10)
    
    -- Yeni eklenen satırdaki tutarı ve işlem tipini alıyoruz
    SELECT @Tutar = Tutar, @Tip = IslemTipi FROM INSERTED

    IF @Tip = 'Bagis'
    BEGIN
        UPDATE AskidaYemekHavuzu 
        SET ToplamBakiye = ToplamBakiye + @Tutar, SonGuncelleme = GETDATE()
    END
    ELSE IF @Tip = 'Kullanim'
    BEGIN
        UPDATE AskidaYemekHavuzu 
        SET ToplamBakiye = ToplamBakiye - @Tutar, SonGuncelleme = GETDATE()
    END
END
GO
-- 10. GÖRÜNÜMLER (VIEWS) 

-- Görünüm 1: Aktif restoranların menülerini ve fiyatlarını listeler [cite: 27]
GO
CREATE VIEW vw_AktifMenuListesi AS
SELECT R.RestoranAd, U.UrunAd, U.Fiyat
FROM Restoranlar R
INNER JOIN Urunler U ON R.RestoranID = U.RestoranID
WHERE R.IsActive = 1 AND U.IsActive = 1; -- Soft Delete kontrolü [cite: 20]
GO

-- Görünüm 2: Askıda yemek havuzunun güncel durumunu gösterir [cite: 28]
CREATE VIEW vw_AskidaHavuzOzet AS
SELECT ToplamBakiye, SonGuncelleme
FROM AskidaYemekHavuzu;
GO
-- 11. İNDEKSLER (INDEX) 
-- E-posta ile giriş yapıldığı için hızlı arama sağlar
CREATE INDEX IDX_KullaniciEposta ON Kullanicilar(Eposta);

-- Restoran adına göre aramalarda hızı artırır
CREATE INDEX IDX_RestoranAd ON Restoranlar(RestoranAd);
-- 12. İLERİ DÜZEY SORGULAR

-- A. JOIN Kullanımı: Detaylı sipariş fişi sorgusu [cite: 22]
SELECT S.SiparisID, K.Ad + ' ' + K.Soyad AS Musteri, R.RestoranAd, S.ToplamTutar, S.SiparisDurumu
FROM Siparisler S
INNER JOIN Kullanicilar K ON S.MusteriID = K.KullaniciID
INNER JOIN Restoranlar R ON S.RestoranID = R.RestoranID;

-- B. Agregasyon: Restoran bazlı toplam sipariş tutarları [cite: 23]
SELECT R.RestoranAd, SUM(S.ToplamTutar) AS ToplamCiro, AVG(S.ToplamTutar) AS OrtalamaSepet
FROM Restoranlar R
LEFT JOIN Siparisler S ON R.RestoranID = S.RestoranID
GROUP BY R.RestoranAd
HAVING COUNT(S.SiparisID) > 0;

-- C. Alt Sorgu (Subquery): Hiç bağış yapmamış aktif kullanıcılar 
SELECT Ad, Soyad, Eposta 
FROM Kullanicilar 
WHERE KullaniciID NOT IN (SELECT DISTINCT KullaniciID FROM AskidaYemekIslemleri WHERE IslemTipi = 'Bagis');
-- 13. MOCK DATA (SİSTEMİ DOLDURMA) [cite: 17, 18]

-- Müşteri Sayısını 20'ye Tamamlama
INSERT INTO Kullanicilar (Ad, Soyad, Eposta, Telefon, KullaniciTipi, IsVerified)
VALUES 
('Can', 'Öz', 'can@mail.com', '05550001122', 'Musteri', 0),
('Ece', 'Su', 'ece@mail.com', '05553334455', 'Musteri', 1), -- İhtiyaç Sahibi
('Ali', 'Can', 'ali@mail.com', '05559990011', 'Musteri', 0),
('Ayşe', 'Nur', 'ayse@mail.com', '05441112233', 'Musteri', 0);
-- (Bu şekilde 20'ye tamamlayacak şekilde devam edebilirsin)

-- 5 Restoran Tamamlama 
INSERT INTO Restoranlar (YoneticiID, RestoranAd, Puan)
VALUES 
(2, 'Lezzet Durağı', 4.5),
(2, 'Mühendis Pizzacı', 4.2),
(2, 'Vegan Dünyası', 3.9),
(2, 'Sokak Lezzetleri', 4.7);

-- Ürünleri Çoğaltma (Her restorana farklı ürünler) 
INSERT INTO Urunler (RestoranID, UrunAd, Fiyat)
VALUES 
(2, 'Tavuk Döner', 120.00), (2, 'Ayran', 20.00),
(3, 'Karışık Pizza', 250.00), (3, 'Kola', 45.00),
(4, 'Falafel Dürüm', 110.00), (5, 'Köfte Ekmek', 140.00);

-- Bağış Yapma Testi
INSERT INTO AskidaYemekIslemleri (KullaniciID, IslemTipi, Tutar, GizliBagis)
VALUES (1, 'Bagis', 500.00, 1); -- Ahmet 500 TL bağışladı (Gizli)

-- İhtiyaç Sahibi Kullanımı
INSERT INTO AskidaYemekIslemleri (KullaniciID, IslemTipi, Tutar)
VALUES (3, 'Kullanim', 150.00); -- Mehmet havuzdan 150 TL harcadı

-- Son Durumu Kontrol Et
SELECT * FROM vw_AskidaHavuzOzet; -- View kullanarak havuzu gör [cite: 28]

-- Günlük Sipariş Sayısı Analizi
SELECT CAST(SiparisTarihi AS DATE) AS Gun, COUNT(*) AS GunlukSiparisSayisi
FROM Siparisler
GROUP BY CAST(SiparisTarihi AS DATE);

-- ÖRNEK VERİLERLE SİSTEMİ CANLANDIRMA

-- Önce havuzu sıfırla (eğer içinde veri yoksa başlangıç kaydı oluştur)
IF NOT EXISTS (SELECT 1 FROM AskidaYemekHavuzu)
    INSERT INTO AskidaYemekHavuzu (ToplamBakiye) VALUES (0);

-- 1. TEST: Hayırsever Ahmet 1000 TL bağış yapıyor
INSERT INTO AskidaYemekIslemleri (KullaniciID, IslemTipi, Tutar, GizliBagis)
VALUES (1, 'Bagis', 1000.00, 0);

-- 2. TEST: Hayırsever Caner 500 TL bağış yapıyor
INSERT INTO AskidaYemekIslemleri (KullaniciID, IslemTipi, Tutar, GizliBagis)
VALUES (2, 'Bagis', 500.00, 1); -- Gizli bağış

-- 3. TEST: İhtiyaç sahibi (IsVerified=1 olan) bir kullanıcı 200 TL'lik harcama yapıyor
INSERT INTO AskidaYemekIslemleri (KullaniciID, IslemTipi, Tutar)
VALUES (3, 'Kullanim', 200.00);

-- 4. TEST: Örnek bir sipariş oluşturma
INSERT INTO Siparisler (MusteriID, RestoranID, KuryeID, ToplamTutar, SiparisDurumu, AskidaMi)
VALUES (3, 1, 2, 200.00, 'Teslim Edildi', 1); -- Bu sipariş askıdan karşılandı

-- Güncel durumu görmek için
SELECT * FROM vw_AskidaHavuzOzet;

-- Kim ne kadar bağış yapmış/harcamış listesi
SELECT K.Ad, K.Soyad, A.IslemTipi, A.Tutar, A.IslemTarihi
FROM AskidaYemekIslemleri A
JOIN Kullanicilar K ON A.KullaniciID = K.KullaniciID;