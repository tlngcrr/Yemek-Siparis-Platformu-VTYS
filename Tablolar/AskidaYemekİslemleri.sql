
ASKIDA YEMEK İŞLEMLERİ [cite: 8]
-- Bağış yapan hayırseverlerin ve kullanan ihtiyaç sahiplerinin kaydı.
CREATE TABLE AskidaYemekIslemleri (
    IslemID INT PRIMARY KEY IDENTITY(1,1),
    KullaniciID INT FOREIGN KEY REFERENCES Kullanicilar(KullaniciID),
    IslemTipi NVARCHAR(10) CHECK (IslemTipi IN ('Bagis', 'Kullanim')),
    Tutar DECIMAL(10,2) NOT NULL,
    GizliBagis BIT DEFAULT 0, -- Hayırseverin kimliğini gizleme opsiyonu [cite: 7]
    IslemTarihi DATETIME DEFAULT GETDATE()
);