GO
CREATE TRIGGER trg_HavuzBakiyeGuncelle
ON AskidaYemekIslemleri
AFTER INSERT
AS
BEGIN
    DECLARE @Tutar DECIMAL(10,2), @Tip NVARCHAR(10)
    SELECT @Tutar = Tutar, @Tip = IslemTipi FROM INSERTED

    IF @Tip = 'Bagis'
        UPDATE AskidaYemekHavuzu SET ToplamBakiye = ToplamBakiye + @Tutar, SonGuncelleme = GETDATE()
    ELSE IF @Tip = 'Kullanim'
        UPDATE AskidaYemekHavuzu SET ToplamBakiye = ToplamBakiye - @Tutar, SonGuncelleme = GETDATE()
END
GO

-- Kural: Sipariş toplam tutarı negatif olamaz
ALTER TABLE Siparisler ADD CONSTRAINT CHK_SiparisTutari CHECK (ToplamTutar >= 0);