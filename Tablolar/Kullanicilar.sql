-- VTYS-1 Dönem Projesi: Çevrimiçi Yemek Sipariþ Platformu [cite: 1]
-- Yazar: Tülin Geçer (Bilgisayar Mühendisliði Öðrencisi) [cite: 1, 3]

-- 1. KULLANICILAR TABLOSU [cite: 5]
-- Müþteri, restoran ve kurye verileri burada tutulur.
CREATE TABLE Kullanicilar (
    KullaniciID INT PRIMARY KEY IDENTITY(1,1),
    Ad NVARCHAR(50) NOT NULL,
    Soyad NVARCHAR(50) NOT NULL,
    Eposta NVARCHAR(100) UNIQUE NOT NULL, -- [cite: 16]
    Telefon CHAR(11) CHECK (LEN(Telefon) = 11), -- [cite: 14]
    KullaniciTipi NVARCHAR(20) CHECK (KullaniciTipi IN ('Musteri', 'Restoran', 'Kurye')),
    IsVerified BIT DEFAULT 0, -- Ýhtiyaç sahibi doðrulamasý için [cite: 7]
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
-- Baðýþlarýn toplandýðý ana kasa.
CREATE TABLE AskidaYemekHavuzu (
    HavuzID INT PRIMARY KEY IDENTITY(1,1),
    ToplamBakiye DECIMAL(18,2) DEFAULT 0 CHECK (ToplamBakiye >= 0),
    SonGuncelleme DATETIME DEFAULT GETDATE()
);

-- 5. ASKIDA YEMEK ÝÞLEMLERÝ [cite: 8]
-- Baðýþ yapan hayýrseverlerin ve kullanan ihtiyaç sahiplerinin kaydý.
CREATE TABLE AskidaYemekIslemleri (
    IslemID INT PRIMARY KEY IDENTITY(1,1),
    KullaniciID INT FOREIGN KEY REFERENCES Kullanicilar(KullaniciID),
    IslemTipi NVARCHAR(10) CHECK (IslemTipi IN ('Bagis', 'Kullanim')),
    Tutar DECIMAL(10,2) NOT NULL,
    GizliBagis BIT DEFAULT 0, -- Hayýrseverin kimliðini gizleme opsiyonu [cite: 7]
    IslemTarihi DATETIME DEFAULT GETDATE()
);
