🍱 Çevrimiçi Yemek Sipariş Platformu Veritabanı Tasarımı 
Bu proje, VTYS-1 dersi kapsamında geliştirilmiş; klasik yemek sipariş süreçlerini ve özel "Askıda Yemek" modülünü içeren, 3. Normal Form'a (3NF) uygun bir veritabanı tasarımıdır. 
🚀 Proje İçeriği
Kullanıcı Yönetimi: Müşteri, Restoran ve Kurye rolleri.  Menü Sistemi: Restoran bazlı ürün yönetimi ve fiyatlandırma.
Sipariş Takibi: Siparişlerin durum yönetimi ve detaylandırılması.  
Askıda Yemek Modülü: Hayırseverlerin bağış yapabildiği ve ihtiyaç sahiplerinin yararlanabildiği özel havuz sistemi. 
🧠 İş Kuralları
(Business Rules)Doğrulama: Havuzdan sadece IsVerified durumu onaylanmış (1 olan) kullanıcılar yararlanabilir. 
Otomasyon: AskidaYemekIslemleri tablosuna girilen her bağış veya kullanım, bir Trigger vasıtasıyla AskidaYemekHavuzu bakiyesini otomatik günceller.  
Güvenlik: Kullanıcı e-postaları UNIQUE olarak tanımlanmıştır ve telefon numaraları 11 haneli olacak şekilde CHECK kısıtlamasıyla korunur.  
Veri Saklama: Silinen restoran veya ürünler fiziksel olarak silinmez, IsActive kolonu 0 yapılarak Soft Delete uygulanır.  
🤖 Yapay Zeka (AI) Beyanı
Bu projenin geliştirilme sürecinde Gemini yapay zeka aracı; veritabanı şemasının 3NF uygunluğunun denetlenmesi, tetikleyici (trigger) mantığının kurgulanması ve testler için 100+ satırlık anlamlı sahte veri üretilmesi aşamasında teknik asistan olarak kullanılmıştır. Üretilen kodlar tarafımca MSSQL üzerinde test edilerek doğrulanmıştır.  
