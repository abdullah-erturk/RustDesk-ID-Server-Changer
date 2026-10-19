<a href="https://buymeacoffee.com/abdullaherturk" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" style="height: 60px !important;width: 217px !important;" ></a>

# RustDesk ID & Server Changer v4

## Download Link:

[![Stable?](https://img.shields.io/badge/Release-v4-blue.svg?style=flat)](https://github.com/abdullah-erturk/RustDesk-ID-Server-Changer/archive/refs/heads/main.zip)

RustDesk Github: https://github.com/rustdesk/rustdesk

<details>
<summary>🇹🇷 Türkçe</summary>

Bu betik ile RustDesk ID bilgilerinizi ve Sunucu yapılandırmalarınızı dilediğiniz gibi değiştirebilirsiniz. Betik, işletim sisteminizin dilini otomatik algılayıp arayüzünü ona göre (Türkçe veya İngilizce) ayarlar, taşınabilir (portable) RustDesk sürümleriyle uyumludur ve kurulum dizinini Windows Kayıt Defteri üzerinden dinamik olarak tespit eder.

Menü açıldığında üst kısımda **mevcut ID** ve **aktif sunucu** (Public / Private + adres) anlık olarak gösterilir. Her işlemin ardından değişiklik `rustdesk.exe --get-id` ile **doğrulanır** ve yapılan işlemler zaman damgasıyla bir **log dosyasına** yazılır.

Betiğin sunduğu seçenekler:

**1. "RustDesk ID'sini bilgisayar adıyla değiştir"**
RustDesk ID'si otomatik olarak bilgisayarın adına dönüşür. Özellikle bilgisayar laboratuvarı gibi ortamlarda imaj atıldıktan sonra ID'lerin aynı kalması sorununu çözer. Yeniden başlatma gerekmez. Bilgisayar adı, işletim sisteminin gerektirdiği minimum ID uzunluğundan kısaysa (bkz. 3. seçenek), işlem yapılmadan önce kullanıcı uyarılır.

**2. "RustDesk ID'sini 9 haneli rastgele sayılarla değiştir"**
ID, 9 haneli rastgele bir değere dönüştürülür. Bu seçenek RustDesk'in doğal ID formatıyla birebir uyumlu olduğu için tüm işletim sistemlerinde güvenilir biçimde çalışır. Yeniden başlatma gerekmez.

**3. "RustDesk ID'sini belirttiğiniz değere ayarlayın"**
ID tamamen sizin belirlediğiniz bir değere dönüştürülür. Minimum uzunluk işletim sistemine göre otomatik belirlenir: **Windows 10/11 → 6, Windows 7/8.x → 7, Windows Server → 8 karakter.** (RustDesk bu alt sınırdan kısa özel ID'leri reddedip rastgele bir ID atar.) Bu seçenek artık tüm Windows sürümlerinde kullanılabilir.

**4. "Public Sunucuya Geç (Private Sunucu Bilgisini Temizle)"**
Aktif özel sunucu yapılandırmanız varsa güvenli biçimde yedekler ve varsayılan Public sunuculara geçer. Zaten Public'teyseniz işlem yapmaz. Not: Mevcut ID harf/özel karakter içeriyorsa, Public sunucunun bu ID'yi kabul etmeyip numerik bir ID atayabileceği konusunda uyarır.

**5. "Private Sunucuya Geç (Yedeklenen Private Sunucu Bilgisini Uygula)"**
Daha önce yedeklenmiş özel sunucu ayarlarınızı bulup geri yükler. Yedek yoksa önce ayarları girmeniz gerektiğini bildirir.

**6. "Yeni Private Sunucu Tanımla"**
Sunucu IP/Host adresini ve Key bilgisini isteyip özel sunucu yapılandırmasını oluşturur.

**7. "Tam Yapılandırmayı İçe Aktar (Config String)"**
RustDesk'in dışa aktardığı tam yapılandırma dizesini (ID/Relay/API sunucu + Key) tek seferde içe aktarır. Dize betik tarafından çözümlenip hem servis hem kullanıcı config dosyasına yazılır.

**8. "Kalıcı Şifre Ayarla"**
RustDesk kalıcı erişim şifresini (en az 6 karakter) ayarlar.

**9. "Son ID Değişikliğini Geri Al (Undo)"**
ID değiştirilmeden önce alınan yedeği kullanarak önceki ID'ye geri döner.

**P. "Ayarlar Kilit PIN'ini Sıfırla"**
RustDesk ayarlarını koruyan kilit PIN'ini (`unlock_pin`), mevcut PIN'i bilmenize gerek kalmadan kaldırır. Sonrasında yeni PIN'i RustDesk arayüzünden belirleyebilirsiniz.

**0. "Private Sunucu Yedeklerini Sil"**
Saklanmış özel sunucu yedek dosyalarını temizler.

Tüm işlemler, config dosyası düzenlenirken **tüm RustDesk süreçlerini (tüm oturumlardaki)** durdurur; bu sayede RDP/çoklu oturum (örn. Windows Server) ortamlarında çalışan bir GUI'nin değişikliği ezmesi engellenir. İşlem sonrası kullanıcı oturumundaki GUI yeniden başlatılarak yeni ID/sunucu anında yansıtılır (servis süreci korunur).

> **Güncelleme (v3.1):** [#13](https://github.com/abdullah-erturk/RustDesk-ID-Server-Changer/issues/13) referans alınarak uzak bağlantı kopma sorunları çözülmüş; servis kapatma işlemleri konfigürasyon sonrasına taşınmıştır.

> **Güncelleme (v3.2):** [#15](https://github.com/abdullah-erturk/RustDesk-ID-Server-Changer/issues/15) referans alınarak kurulum dizini Windows Kayıt Defteri üzerinden dinamik tespit edilmeye başlanmış; Windows 7 / PowerShell 2.0 uyumluluk sorunları giderilmiştir.

> **Güncelleme (v3.3):** [#17](https://github.com/abdullah-erturk/RustDesk-ID-Server-Changer/pull/17) referans alınarak, scriptin farklı sürücülerden (USB vb.) çalıştırıldığında hata vermesine neden olan dizin değiştirme sorunu çözülmüştür.

> **Güncelleme (v4):** Durum göstergesi (mevcut ID + sunucu), işlem sonrası `--get-id` ile doğrulama, log kaydı; yeni seçenekler: tam yapılandırma içe aktarma (7), kalıcı şifre (8), son ID değişikliğini geri alma (9) ve ayarlar kilit PIN'ini sıfırlama (P). ID değiştirme artık RustDesk 1.5'in `enc_id` yapısıyla uyumludur ve değişiklikler hem servis hem kullanıcı config dosyasına uygulanır. Özel ID için minimum uzunluk işletim sistemine göre otomatik ayarlanır (Win10/11: 6, Win7/8: 7, Server: 8). Config dosyası düzenlenirken tüm RustDesk süreçleri durdurularak çoklu oturum (Windows Server/RDP) ortamlarındaki "ID geri dönüyor" sorunu giderilmiştir. Kullanıcı girdileri artık PowerShell'e ortam değişkenleriyle güvenli biçimde aktarılır.

</details>

<details>
<summary>🇬🇧 English</summary>

This script lets you change your RustDesk ID and Server configuration as you wish. It auto-detects your OS display language (Turkish or English), works with portable RustDesk builds, and detects the install directory dynamically via the Windows Registry.

When the menu opens, the header shows the **current ID** and the **active server** (Public / Private + address) in real time. After each operation the change is **verified** with `rustdesk.exe --get-id`, and every operation is written with a timestamp to a **log file**.

Options:

**1. "Set RustDesk ID with computer name"**
The ID becomes the computer's name automatically. Useful in lab/imaged environments where IDs stay identical after deployment. No reboot needed. If the computer name is shorter than the OS-required minimum ID length (see option 3), the user is warned before any action is taken.

**2. "Set RustDesk ID with 9-digit random numbers"**
The ID becomes a random 9-digit value. Because this matches RustDesk's native ID format, it works reliably on every Windows version. No reboot needed.

**3. "Set RustDesk ID to the value you specify"**
The ID becomes a value you choose. The minimum length is set automatically by OS: **Windows 10/11 → 6, Windows 7/8.x → 7, Windows Server → 8 characters.** (RustDesk rejects shorter custom IDs and assigns a random one.) This option now works on all Windows versions.

**4. "Set Public Server (Clear Custom Server Info)"**
Backs up any active custom server config and switches to the default Public servers. Does nothing if already on Public. Note: if the current ID contains letters/custom characters, it warns that the Public server may reject it and assign a numeric ID.

**5. "Set Private Server (Apply Backed-up Custom Server Info)"**
Finds and restores a previously backed-up custom server config. If no backup exists, it prompts you to configure the server first.

**6. "Set New Private Server"**
Asks for the server IP/Host and Key, then writes the custom server configuration.

**7. "Import Full Configuration (Config String)"**
Imports the full configuration string exported from RustDesk (ID/Relay/API server + Key) in one step. The string is decoded by the script and written to both the service and user config files.

**8. "Set Permanent Password"**
Sets the RustDesk permanent access password (at least 6 characters).

**9. "Undo Last ID Change"**
Restores the previous ID using the backup taken before the last change.

**P. "Reset Settings-Lock PIN"**
Removes the PIN (`unlock_pin`) that protects RustDesk settings — without needing to know the current PIN. You can then set a new PIN from the RustDesk interface.

**0. "Delete Custom Server Backups"**
Clears the stored custom-server backup files.

While editing config files, all operations stop **every RustDesk process (across all sessions)**, so a GUI running in an RDP/multi-session environment (e.g. Windows Server) cannot overwrite the change. Afterwards the user-session GUI is restarted so the new ID/server shows instantly (the service process is preserved).

> **Update (v3.1):** Thanks to [#13](https://github.com/abdullah-erturk/RustDesk-ID-Server-Changer/issues/13), remote-connection drop issues were fixed; service termination now runs after configuration is applied.

> **Update (v3.2):** Thanks to [#15](https://github.com/abdullah-erturk/RustDesk-ID-Server-Changer/issues/15), the install directory is detected dynamically via the Windows Registry; Windows 7 / PowerShell 2.0 compatibility issues were resolved.

> **Update (v3.3):** Thanks to [#17](https://github.com/abdullah-erturk/RustDesk-ID-Server-Changer/pull/17), a directory-change bug that caused errors when running from other drives (USB, etc.) was fixed.

> **Update (v4):** Status indicator (current ID + server), post-operation verification via `--get-id`, and logging; new options: import full configuration (7), set permanent password (8), undo last ID change (9), and reset settings-lock PIN (P). ID changing is now compatible with RustDesk 1.5's `enc_id` storage and is applied to both the service and user config files. The minimum length for a custom ID is set automatically by OS (Win10/11: 6, Win7/8: 7, Server: 8). While editing config files, all RustDesk processes are stopped, fixing the "ID reverts" problem in multi-session (Windows Server/RDP) environments. User input is now passed to PowerShell safely via environment variables.

</details>

Sample preview:

![sample](https://raw.githubusercontent.com/abdullah-erturk/RustDesk-ID-Server-Changer/main/preview.jpg)
