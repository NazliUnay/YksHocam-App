using Microsoft.AspNetCore.Mvc;
using YksHocamAPI.Models;
using System.Linq;
using System;
using HtmlAgilityPack; // NuGet'ten yüklenmelidir: dotnet add package HtmlAgilityPack
using System.Net.Http;
using System.Threading.Tasks;

namespace YksHocamAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class KullanicilarController : ControllerBase
    {
        private readonly YksHocamDbContext _context;

        public KullanicilarController(YksHocamDbContext context)
        {
            _context = context;
        }

        // GİRİŞ YAPMA
        [HttpPost("Giris")]
        public IActionResult Giris([FromBody] GirisModel veri)
        {
            var girilenEmail = veri.Email.Trim();
            var girilenSifre = veri.Sifre.Trim();

            // ToList() SİLİNDİ. Sorgu doğrudan veritabanında çalışır (Hızlıdır).
            var user = _context.Kullanicilar
                .FirstOrDefault(x => x.Email == girilenEmail && x.Sifre == girilenSifre);

            if (user != null)
            {
                return Ok(new
                {
                    message = "Giriş Başarılı",
                    userId = user.KullaniciId,
                    adSoyad = user.AdSoyad,
                    email = user.Email,
                    alan = user.Alan,
                    profilFotoUrl = user.ProfilFotoUrl
                });
            }
            return Unauthorized(new { message = "Hatalı Email veya Şifre" });
        }
        // KAYIT OLMA
        [HttpPost("Ekle")]
        public IActionResult Ekle([FromBody] Kullanicilar yeniKullanici)
        {
            var mevcutKullanici = _context.Kullanicilar.FirstOrDefault(x => x.Email == yeniKullanici.Email);
            if (mevcutKullanici != null)
            {
                return BadRequest(new { message = "Bu email adresi zaten kayıtlı." });
            }

            yeniKullanici.KayitTarihi = DateTime.Now;
            _context.Kullanicilar.Add(yeniKullanici);
            _context.SaveChanges();
            return Ok(new { message = "Kayıt Başarılı", id = yeniKullanici.KullaniciId });
        }

        // ŞİFRE SIFIRLAMA
        [HttpPost("SifreSifirla")]
        public IActionResult SifreSifirla([FromBody] SifreSifirlaModel veri)
        {
            if (string.IsNullOrEmpty(veri.Email))
                return BadRequest(new { message = "Email alanı boş olamaz." });

            string arananEmail = veri.Email.Trim();

            var kullanici = _context.Kullanicilar
                .ToList()
                .FirstOrDefault(x => x.Email.ToLower() == arananEmail.ToLower());

            if (kullanici != null)
            {
                return Ok(new { message = "Sifirlama baglantisi gonderildi", durum = true });
            }
            return NotFound(new { message = "Bu email adresine ait kayit bulunamadi", durum = false });
        }
        // SINAV TARİHİ (Sabit ve Güvenli Veri)
        [HttpGet("CanliSinavTarihi")]
        public IActionResult GetCanliSinavTarihi()
        {
            try
            {
                // Hedef Sınav Tarihi: 20 Haziran 2026, Saat 10:15
                var sinavTarihi = new DateTime(2026, 6, 20, 10, 15, 0);

                return Ok(new
                {
                    tarih = sinavTarihi,
                    durum = "Güncel",
                    mesaj = "2026 YKS Geri Sayım Başladı"
                });
            }
            catch (Exception ex)
            {
                // Hata durumunda bile uygulamanın çökmemesi için yedek tarih döndürülür
                return Ok(new { tarih = new DateTime(2026, 6, 20, 10, 15, 0), durum = "Yedek" });
            }
        }

        // PROFİL GÜNCELLEME
        [HttpPut("Guncelle/{id}")]
        public IActionResult Guncelle(int id, [FromForm] int KullaniciId, [FromForm] string AdSoyad, [FromForm] string Email, [FromForm] string Alan, IFormFile? ProfilFoto)
        {
            if (id != KullaniciId) return BadRequest(new { message = "ID Hatası" });

            var user = _context.Kullanicilar.FirstOrDefault(x => x.KullaniciId == id);
            if (user == null) return NotFound(new { message = "Kullanıcı yok" });

            user.AdSoyad = AdSoyad;
            user.Email = Email;
            user.Alan = Alan;

            // Fotoğraf gelmişse işle
            if (ProfilFoto != null && ProfilFoto.Length > 0)
            {
                // Dosyayı sunucuya kaydetmek için bir yol oluştur (Örn: wwwroot/uploads)
                var path = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot/uploads");
                if (!Directory.Exists(path)) Directory.CreateDirectory(path);

                var dosyaAdi = Guid.NewGuid().ToString() + Path.GetExtension(ProfilFoto.FileName);
                var tamYol = Path.Combine(path, dosyaAdi);

                using (var stream = new FileStream(tamYol, FileMode.Create))
                {
                    ProfilFoto.CopyTo(stream);
                }

                user.ProfilFotoUrl = "/uploads/" + dosyaAdi; // Veritabanına dosya yolunu kaydet
            }

            _context.SaveChanges();
            return Ok(new { message = "Güncelleme Başarılı", fotoUrl = user.ProfilFotoUrl });
        }
        // İSTATİSTİKLER 
        [HttpGet("Istatistikler/{userId}")]
        public IActionResult GetIstatistikler(int userId)
        {
            try
            {
                // Çalışma Süresi: Pomodoro tablosundan toplam dakika
                var toplamDakika = _context.PomodoroOturumlaris
                    .Where(x => x.KullaniciId == userId)
                    .Sum(x => x.SureDakika ?? 0);

                string calismaStr = toplamDakika >= 60
                    ? $"{(toplamDakika / 60.0):N1} Saat"
                    : $"{toplamDakika} Dakika";

                // Bitirilen Konular: KullanıcıKonuTakips tablosundan Tamamlandi=true olanları say
                var bitenKonuSayisi = _context.KullaniciKonuTakips
                    .Count(x => x.KullaniciId == userId && x.TamamlandiMi == true);

                return Ok(new
                {
                    calisma = calismaStr,
                    konu = $"{bitenKonuSayisi} Konu"
                });
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = "Hata oluştu: " + ex.Message });
            }
        }

    } // Controller Class Sonu

    // --- MODELLER (DTOs) ---

    public class GirisModel
    {
        public string Email { get; set; } = "";
        public string Sifre { get; set; } = "";
    }

    public class SifreSifirlaModel
    {
        public string Email { get; set; } = "";
    }

    public class ProfilGuncelleModel
    {
        public int KullaniciId { get; set; }
        public string AdSoyad { get; set; } = "";
        public string Email { get; set; } = "";
        public string Alan { get; set; } = "";
        public string? ProfilFoto { get; set; }
    }

}