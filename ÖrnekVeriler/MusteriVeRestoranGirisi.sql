-- Örnek Müşteri ve Restoran Yöneticisi Girişi
INSERT INTO Kullanicilar (Ad, Soyad, Eposta, Telefon, KullaniciTipi, IsVerified)
VALUES 
('Ahmet', 'Yilmaz', 'ahmet@mail.com', '05551112233', 'Musteri', 0),
('Tulin', 'Gecer', 'tulin@mail.com', '05554445566', 'Restoran', 0),
('Mehmet', 'Demir', 'mehmet@mail.com', '05557778899', 'Musteri', 1); -- İhtiyaç sahibi doğrulanmış [cite: 7]

-- Örnek Restoran Girişi
INSERT INTO Restoranlar (YoneticiID, RestoranAd, Puan)
VALUES (2, 'Mühendis Kafe', 4.8); -- [cite: 14]

-- Örnek Ürün Girişi
INSERT INTO Urunler (RestoranID, UrunAd, Fiyat)
VALUES (1, 'Mercimek Çorbası', 45.00), (1, 'Adana Kebap', 180.00);