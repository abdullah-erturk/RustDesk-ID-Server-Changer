<a href="https://buymeacoffee.com/abdullaherturk" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" style="height: 60px !important;width: 217px !important;" ></a>

# RustDesk ID & Server Changer v3

## Download Link:

[![Stable?](https://img.shields.io/badge/Release-v1.svg?style=flat)](https://github.com/abdullah-erturk/RustDesk-ID-Server-Changer/archive/refs/heads/main.zip)

RustDesk Github: https://github.com/rustdesk/rustdesk

<details>
<summary>🇹🇷 Türkçe</summary>

Bu betik ile RustDesk ID bilgilerinizi ve Sunucu yapılandırmalarınızı dilediğiniz gibi değiştirebilirsiniz. Betik, işletim sisteminizin dilini otomatik olarak algılayıp arayüzünü ona göre (Türkçe veya İngilizce) ayarlar. Aynı zamanda taşınabilir (portable) RustDesk sürümleriyle de uyumlu çalışacak şekilde güncellenmiştir.

Betiğin sunduğu seçenekler için detaylı açıklamalar:

**1. "RustDesk ID'sini bilgisayar adıyla değiştir"**
Bu seçenek ile RustDesk uzak bağlantı programının ID bilgisi otomatik olarak kurulu olduğu bilgisayarın adına dönüşecektir.
Özellikle bilgisayar laboratuvarı gibi ortamlarda imaj atıldıktan sonra RustDesk ID bilgileri bazen değişmemektedir; bu betik ile bu sorun çözülür. Yeniden başlatmaya gerek yoktur.

**2. "RustDesk ID'sini 9 haneli rastgele sayılarla değiştir"**
Bu seçenek ile RustDesk uzak bağlantı programının ID bilgisi 9 haneli rastgele rakamlardan oluşturulacak bir değere dönüştürülür. Yeniden başlatmaya gerek yoktur.

**3. "RustDesk ID'sini belirttiğiniz değere ayarlayın."**
Bu seçenek ile RustDesk uzak bağlantı programının ID bilgisi tamamen kullanıcının belirteceği bir değere dönüştürülür. Yeniden başlatmaya gerek yoktur. (Not: Bu seçenek yalnızca Windows 10 ve üzeri sistemlerde desteklenmektedir.)

**4. "Public Sunucuya Geç (Özel Sunucu Bilgisini Temizle)"**
Eğer aktif bir özel sunucu yapılandırmanız varsa, bu seçenek bu ayarları güvenli bir şekilde yedekler ve RustDesk'i varsayılan Public (Genel) sunuculara geçirir. Eğer zaten Public sunucudaysanız, hiçbir işlem yapmaz ve sizi uyarır.

**5. "Private Sunucuya Geç (Özel Sunucu Bilgisini Uygula)"**
Bu seçenek, daha önce yedeklenmiş olan özel sunucu ayarlarınızı bularak geri yükler ve manuel herhangi bir ayar yapmanıza gerek kalmadan Özel sunucunuza sorunsuz bir şekilde geri dönmenizi sağlar. Eğer sistemde özel bir sunucu yedeği yoksa sizi ilk olarak ayarlarınızı girmeniz konusunda uyarır.

**6. "Yeni Özel Sunucu Tanımla"**
Daha önce girilmiş hiçbir özel sunucu ayarınız yoksa veya yepyeni bir sunucu eklemek istiyorsanız bu seçeneği kullanabilirsiniz. Sizden sadece Sunucu IP/Host adresini ve Key bilgisini isteyip konfigürasyonu tamamlar. Standart API portlarıyla (21114 vb.) tam uyumlu çalışır.

**7. "Private Sunucu Yedeklerini Sil"**
Bu seçenek, bilgisayarınızda daha önceden saklanmış olan özel sunucu (Private Server) yedek yapılandırma dosyalarını tamamen temizler. Sunucu adresinizi değiştirmek veya sistemde kayıtlı olan eski sunucu izlerini silip sıfırdan temiz bir kurulum yapmak istediğinizde kullanılır.

Tüm komut dosyaları Windows 7, 8.1, 10 ve 11'de test edilmiştir (PowerShell 2.0 tam uyumlu). Yalnızca "Özel ID Belirleme" (3. Seçenek) işletim sistemi kısıtlamalarından dolayı Windows 10 ve üzeri gerektirir.

> **Güncelleme (v3.1):** T3Cabon adlı kullanıcının açtığı [#13 numaralı bildirim](https://github.com/abdullah-erturk/RustDesk-ID-Server-Changer/issues/13) referans alınarak, uzak bağlantı kopma sorunları çözülmüş; servis kapatma işlemleri konfigürasyon uygulama sonrasına taşınmıştır.

> **Güncelleme (v3.2):** [#15 numaralı bildirim](https://github.com/abdullah-erturk/RustDesk-ID-Server-Changer/issues/15) referans alınarak, RustDesk kurulum dizini artık doğrudan Windows Kayıt Defteri (Registry) üzerinden dinamik olarak tespit edilmektedir. Ayrıca bizim tarafımızdan tespit edilen Windows 7 ve PowerShell 2.0 genel uyumluluk sorunları da bu sürümde çözülmüş; 3. seçenek (Özel ID Belirleme) Windows 10 ve üzeri sistemlerle sınırlandırılmıştır.

> **Güncelleme (v3.3):** robpomeroy tarafından gönderilen [#17 numaralı Pull Request](https://github.com/abdullah-erturk/RustDesk-ID-Server-Changer/pull/17) referans alınarak, scriptin farklı sürücülerden (örneğin USB bellek) çalıştırıldığında hata vermesine neden olan dizin değiştirme (`cd`) sorunu çözülmüştür.

</details>

<details>
<summary>🇬🇧 English</summary>

You will be able to change the RustDesk ID information and Server configurations as you wish with the script. The script automatically detects your OS language and adjusts its interface accordingly. It has also been updated to be fully compatible with portable RustDesk versions.

Detailed description for options in the script:

**1. "Set RustDesk ID with computer name"**
With this option, the ID information of the RustDesk remote connection program will automatically turn into the name of the host computer.
RustDesk ID information sometimes does not change after image deployment in computer laboratory environments; the problem will be solved with this script file. There is no need to reboot.

**2. "Set RustDesk ID with 9-digit random numbers"**
With this option, the ID information of the RustDesk remote connection program will be converted into a value created from 9-digit random numbers. There is no need to reboot.

**3. "Set the RustDesk ID to the value you specify"**
With this option, the ID information of the RustDesk remote connection program will be converted to the value specified by the user. There is no need to reboot. (Note: This option is only supported on Windows 10 and later systems.)

**4. "Set Public Server (Clear Custom Server Info)"**
If you have a custom/private server configuration active, this option will back it up securely and switch RustDesk to the default Public servers. If you are already on the Public server, it will gracefully ignore the request.

**5. "Set Private Server (Apply Custom Server Info)"**
This option checks for a previously backed-up custom server configuration and restores it, seamlessly switching you back to your Private server without manual configuration. If no backup is found, it will prompt you to log into your server first.

**6. "Set New Private Server"**
If you don't have a backup or you want to define a brand-new Private Server, use this option. It will ask for your base Server IP/Host and Key, and automatically configure RustDesk for you. It is fully compatible with standard API ports (like 21114).

**7. "Delete Private Server Backups"**
This option completely clears the previously saved Private Server backup configuration files on your computer. It is very useful when you want to change your server address or completely remove the traces of the old server to start with a clean slate.

All scripts are tested on Windows 7 - 8.1 - 10 and 11 (PowerShell 2.0 fully compatible). Only "Custom ID Setting" (Option 3) requires Windows 10 and later due to OS limitations.

> **Update (v3.1):** Thanks to the [#13 issue](https://github.com/abdullah-erturk/RustDesk-ID-Server-Changer/issues/13) raised by user T3Cabon, remote connection drop issues have been resolved; service termination operations are now executed after configuration is applied.

> **Update (v3.2):** Thanks to the [#15 issue](https://github.com/abdullah-erturk/RustDesk-ID-Server-Changer/issues/15), the RustDesk installation directory is now dynamically detected via the Windows Registry. Additionally, general Windows 7 and PowerShell 2.0 compatibility issues (discovered internally) have been resolved; Option 3 (Custom ID Setting) has been restricted to Windows 10 and later systems.

> **Update (v3.3):** Thanks to the [#17 Pull Request](https://github.com/abdullah-erturk/RustDesk-ID-Server-Changer/pull/17) submitted by robpomeroy, a directory change (`cd`) bug that caused errors when running the script from different drives (e.g., USB flash drives) has been resolved.

</details>

Sample preview:

![sample](https://github.com/abdullah-erturk/RustDesk-ID-Changer/blob/main/preview.jpg)
