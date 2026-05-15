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
