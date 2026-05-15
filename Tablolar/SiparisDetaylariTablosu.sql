

SİPARİŞ DETAYLARI TABLOSU (Her siparişteki ürünler)
CREATE TABLE SiparisDetaylari (
    DetayID INT PRIMARY KEY IDENTITY(1,1),
    SiparisID INT FOREIGN KEY REFERENCES Siparisler(SiparisID),
    UrunID INT FOREIGN KEY REFERENCES Urunler(UrunID),
    Adet INT CHECK (Adet > 0),
    BirimFiyat DECIMAL(10,2)
);