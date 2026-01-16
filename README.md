# 📝 AI-Powered Task Manager

**AI-Powered Task Manager**, modern yazılım mimarisi prensipleri kullanılarak geliştirilmiş hibrit bir görev yönetim platformudur.  
Kullanıcılar görevlerini kategori bazlı organize edebilir, tüm cihazlarda **bulut senkronizasyonu** ile takip edebilir ve **DeepSeek AI** ile akıllı görev önerileri alabilir.

---

## 🏗️ Mimari Yaklaşım

Proje, sürdürülebilirlik ve test edilebilirlik odaklı olarak **Katmanlı Mimari (Layered Architecture)** ve **MVVM (Model-View-ViewModel)** desenleri üzerine inşa edilmiştir.

### Flutter (Mobil) Mimarisi

* **View:** Sadece UI çizimi ve kullanıcı etkileşiminden sorumludur. İş mantığı içermez.
* **ViewModel:** `ChangeNotifier` ve `Provider` ile state yönetimi sağlar; UI ile servisler arasındaki köprü görevini görür.
* **Service Layer:** `Firebase Auth`, `Firestore` ve `DeepSeek API` iletişimini soyutlar.
* **Core:** Hata yönetimi (`AppException`), sabitler ve tema tanımlarını içerir.

### React (Web) Mimarisi

* **Component-Based:** Modüler ve tekrar kullanılabilir bileşenler.
* **Custom Hooks:** `useTasks` hook’u ile iş mantığı UI’dan ayrılmıştır.

---

## 📱 Mobil Uygulama (Flutter / Dart)

* Cross-platform mobil uygulama geliştirme
* `Provider` ile reaktif state yönetimi
* `Firebase Auth` ve `Firestore` entegrasyonu
* Modern Material 3 arayüz ve kategori bazlı renk kodlaması

## 💻 Web Uygulaması (React + Vite)

* Hızlı ve modüler frontend geliştirme
* Material 3 / MUI ile modern UI bileşenleri
* Custom Hooks (`useTasks`) ile iş mantığını UI’dan ayırma

---

## ⚙️ Backend ve AI

* **Firebase:** Kullanıcı kimlik doğrulama ve real-time NoSQL veri tabanı
* **DeepSeek AI:** Görev başlıklarına göre akıllı öneriler (Flask API üzerinden)
* **Diğer:** `http`, `requests` gibi kütüphaneler ile API iletişimi

---

## ⚙️ Kurulum ve Çalıştırma

### 1️⃣ Ön Hazırlık

* Flutter SDK (>= 3.10)
* Node.js (>= 18)
* Python (>= 3.10)

### 3️⃣ Web Uygulaması
* cd web-app
* npm install
* npm run dev

### 4️⃣ AI Backend (Flask)
* cd ai_backend
* python api.py

Not: AI backend, DeepSeek modeline lokal veya servis üzerinden bağlanır. Endpoint aktif değilse öneri özelliği çalışmaz.

## 📸 Ekran Görüntüleri

### Mobil Uygulama
<img width="360" height="800" alt="image" src="https://github.com/user-attachments/assets/e46afee5-a52a-410d-8e48-3bc8c5c34d7e" />
<img width="360" height="800" alt="image" src="https://github.com/user-attachments/assets/43d35a63-54c5-4c06-b253-387aac4dcc8b" />
<img width="360" height="800" alt="image" src="https://github.com/user-attachments/assets/b9f78779-15f4-4e0e-831f-b6a4d8e03bbe" />
<img width="360" height="800" alt="image" src="https://github.com/user-attachments/assets/ce6d0f83-2623-44aa-900a-9e7f20231baa" />
<img width="360" height="800" alt="image" src="https://github.com/user-attachments/assets/1a71f8c6-0217-4c43-b2de-241879019b4c" />
<img width="360" height="800" alt="image" src="https://github.com/user-attachments/assets/fb676d64-8528-4d45-9cd7-64d246c35bf3" />
<img width="360" height="800" alt="image" src="https://github.com/user-attachments/assets/3ece26b0-9d63-4e3a-a761-69bcf96f8a76" />
<img width="360" height="800" alt="image" src="https://github.com/user-attachments/assets/e0d0cd7f-f818-4574-a32c-b872d967960d" />
<img width="360" height="800" alt="image" src="https://github.com/user-attachments/assets/1a4b79f3-fe9b-4e9f-a06b-2c8c4600331e" />

### Web Uygulaması
<img width="500" height="370" alt="Ekran görüntüsü 2026-01-16 132648" src="https://github.com/user-attachments/assets/f843a7fd-f84c-4885-986d-23fed286054c" />


⏳ Gelecek Planları

* Unit Tests: ViewModel ve Service katmanları için test kapsamı %80’in üzerine çıkarılacak.

* Web Uygulaması: Tüm ekranlar tamamlanacak ve kullanıcı deneyimi optimize edilecek.

* Push Notifications & Hatırlatmalar: Firebase Cloud Messaging ile görev hatırlatmaları ve kullanıcı bildirimleri aktif hale getirilecek.

* Security: API katmanı için JWT tabanlı yetkilendirme ve rate-limiting uygulanacak.

* Performans & Optimizasyon: Uygulama yanıt süreleri iyileştirilecek, gereksiz yükler azaltılacak.

* Analytics & İzleme: Kullanıcı davranışları ve hata raporları için analitik ve loglama sistemleri entegre edilecek.
