-- 1. Restoran bazlı toplam kazanç (GROUP BY + SUM)
SELECT R.RestoranAd, SUM(S.ToplamTutar) AS ToplamCiro
FROM Restoranlar R
LEFT JOIN Siparisler S ON R.RestoranID = S.RestoranID
GROUP BY R.RestoranAd;

-- 2. Hangi yemekten kaç adet sipariş verildi? (GROUP BY + COUNT)
SELECT U.UrunAd, COUNT(*) AS SiparisAdedi
FROM Siparisler S
JOIN Urunler U ON S.UrunID = U.UrunID -- (Not: Sipariş detay tablon varsa oradan bağlanır)
GROUP BY U.UrunAd;