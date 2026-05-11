-- VTYS-1 Dönem Projesi: Çevrimiçi Yemek Sipariş Platformu
-- Yazar: Tülin Geçer (Mühendislik Öğrencisi) [cite: 1, 3]

-- 1. KULLANICILAR TABLOSU
-- Sistem gereksinimlerine uygun müşteri, restoran ve kurye verileri [cite: 5]
CREATE TABLE Kullanicilar (
    KullaniciID INT PRIMARY KEY IDENTITY(1,1),
    Ad NVARCHAR(50) NOT NULL,
    Soyad NVARCHAR(50) NOT NULL,
    Eposta NVARCHAR(100) UNIQUE NOT NULL, -- UNIQUE kısıtlaması [cite: 16]
    Telefon CHAR(11) CHECK (LEN(Telefon) = 11), -- CHECK kısıtlaması [cite: 14]
    KullaniciTipi NVARCHAR(20) CHECK (KullaniciTipi IN ('Musteri', 'Restoran', 'Kurye')),
    IsVerified BIT DEFAULT 0, -- İhtiyaç sahibi doğrulaması için (Özel Kural) [cite: 7]
    IsActive BIT DEFAULT 1 -- Soft Delete (Pasife çekme) [cite: 20]
);

-- 2. RESTORANLAR TABLOSU
CREATE TABLE Restoranlar (
    RestoranID INT PRIMARY KEY IDENTITY(1,1),
    YoneticiID INT FOREIGN KEY REFERENCES Kullanicilar(KullaniciID), -- Foreign Key [cite: 13]
    RestoranAd NVARCHAR(100) NOT NULL,
    Puan FLOAT CHECK (Puan BETWEEN 1 AND 5), -- Zorunlu CHECK [cite: 14, 15]
    IsActive BIT DEFAULT 1
);