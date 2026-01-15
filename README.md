# gorev_yonetimi ✅

**Kısa Tanım**

Gorev_yonetimi, kişisel ve iş görevlerinizi oluşturup yönetebileceğiniz bir "yapılacaklar" (task management) uygulamasıdır. Mobil uygulama öncelikli geliştirilmiş; ayrıca basit bir web arayüzü ve AI destekli öneri servisi içerir.

---

## 🚀 Projenin Amacı

- Görev oluşturma, düzenleme, kategorilendirme ve takip etme.
- Kullanıcı kimlik doğrulama ve görev verilerinin bulutta saklanması (Firebase).
- AI destekli kısa ve pratik görev önerileri (yerel model / mikroservis aracılığıyla).

---

## 🧰 Kullanılan Teknolojiler

- Mobil: **Flutter (Dart)**
  - State management: `provider`
  - Backend & veri: `firebase_auth`, `cloud_firestore`
- Web: **React + Vite + MUI (Material UI)**
- AI Backend: **Flask** (AI modeliyle iletişim sağlayan küçük bir servis)
- Diğer: `http`, `provider`, `requests`, vs.

---

## ⚙️ Kurulum & Çalıştırma

1. Depoyu klonlayın:

```bash
git clone <repo-url>
cd gorev_yonetimi
```

2. Flutter uygulamasını çalıştırma:

- Gerekli: Flutter SDK (>= 3.8)

```bash
flutter pub get
flutter run -d <device-id>
```

- Firebase ayarları: Android için `android/app/google-services.json` projede var; iOS için `GoogleService-Info.plist` ekleyin ve kendi Firebase projenize göre yapılandırın.

3. Web uygulaması (development):

```bash
cd web-app
npm install
npm run dev
```

4. AI backend (local):

- Gereksinimler: Python 3.10+, `flask`, `requests`

```bash
pip install flask requests
python ai_backend/api.py
```

- Not: `ai_backend` yerel bir model endpoint'ine (`http://127.0.0.1:1234`) bağlanır. Bu endpoint canlı değilse AI önerileri çalışmaz.

> ⚠️ Not: Firebase ve lokal AI model endpoint'i doğru yapılandırılmalıdır; aksi halde bazı özellikler (auth, firestore, AI) çalışmaz.

---

## 🏗️ Mimari & Klasör Yapısı (Kısa)

- `lib/core`: modeller, servisler, tema, hata sınıfları.
- `features`: ekranlar (`view`), iş mantığı (`viewmodel`), küçük bileşenler (`widgets`).
- `ai_backend`: AI isteklerini yöneten küçük Flask servisi.
- Web: `web-app` klasöründe React + MUI uygulaması.

Bu yaklaşım, kodun okunabilirliğini ve test edilebilirliğini artırır (MVVM benzeri yapı + provider).

---

## 📸 Ekran Görüntüleri

- Repo içinde şu an ekran görüntüsü yok. Dilerseniz `assets/screenshots/` altına PNG ekleyip README'ye referans ekleyebilirim:

```md
![Ana Ekran](assets/screenshots/home.png)
```

---

## ⏳ Süre Kısıtı Sebebiyle Eklenemeyenler & Gelecek İyileştirmeler

- Testler: birim, widget ve API testleri eksik.
- CI/CD: GitHub Actions ile otomatik test ve dağıtım eksik.
- Offline sync & cache stratejileri ve daha güçlü hata/izleme (Sentry/Crashlytics) eklenecek.
- AI: öneri modelinin kişiselleştirilmesi ve güvenlik (rate-limit, yetkilendirme).
- Erişilebilirlik (a11y) ve performans optimizasyonları.

---

## 📝 Kısa Notlar

- README'yi proje ihtiyaçlarına göre daha da detaylandırabilirim (mimarinin diyagramı, API dokümantasyonu, kullanım örnekleri). İsterseniz ekran görüntüleri veya kurulum için Docker/CI adımlarını ekleyeyim.

---
