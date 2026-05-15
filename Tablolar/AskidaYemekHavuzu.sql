

 ASKIDA YEMEK HAVUZU (ÖZEL KURAL) [cite: 7]
-- Bağışların toplandığı ana kasa.
CREATE TABLE AskidaYemekHavuzu (
    HavuzID INT PRIMARY KEY IDENTITY(1,1),
    ToplamBakiye DECIMAL(18,2) DEFAULT 0 CHECK (ToplamBakiye >= 0),
    SonGuncelleme DATETIME DEFAULT GETDATE()
);

