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