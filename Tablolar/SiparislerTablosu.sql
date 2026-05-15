 SİPARİŞLER TABLOSU
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

