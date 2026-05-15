
 RESTORANLAR TABLOSU
CREATE TABLE Restoranlar (
    RestoranID INT PRIMARY KEY IDENTITY(1,1),
    YoneticiID INT FOREIGN KEY REFERENCES Kullanicilar(KullaniciID), -- [cite: 13]
    RestoranAd NVARCHAR(100) NOT NULL,
    Puan FLOAT CHECK (Puan BETWEEN 1 AND 5), -- Zorunlu CHECK [cite: 14, 15]
    IsActive BIT DEFAULT 1 -- [cite: 20]
);

