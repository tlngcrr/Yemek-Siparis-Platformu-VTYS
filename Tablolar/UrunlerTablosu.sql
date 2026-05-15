 ÜRÜNLER TABLOSU (MENÜ) [cite: 5]
CREATE TABLE Urunler (
    UrunID INT PRIMARY KEY IDENTITY(1,1),
    RestoranID INT FOREIGN KEY REFERENCES Restoranlar(RestoranID),
    UrunAd NVARCHAR(100) NOT NULL,
    Fiyat DECIMAL(10,2) CHECK (Fiyat > 0), -- [cite: 14]
    IsActive BIT DEFAULT 1 -- [cite: 20]
);

