using Microsoft.AspNetCore.Mvc;
using YksHocamAPI.Models;
using System.Linq;
using System;

namespace YksHocamAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class BildirimlerController : ControllerBase
    {
        private readonly YksHocamDbContext _context;

        public BildirimlerController(YksHocamDbContext context)
        {
            _context = context;
        }

        // 1. KULLANICIYA AİT BİLDİRİMLERİ GETİR
        // URL: api/Bildirimler/GetByUserId/5
        [HttpGet("GetByUserId/{userId}")]
        public IActionResult GetByUserId(int userId)
        {
            // Senin modelinde KullaniciId 'int?' olduğu için sorguyu buna göre yapıyoruz
            var bildirimler = _context.Bildirimlers
                                      .Where(x => x.KullaniciId == userId)
                                      .OrderByDescending(x => x.Tarih) // En yeni en üstte
                                      .Select(x => new 
                                      {
                                          // Flutter tarafındaki modele uygun hale getiriyoruz
                                          bildirimId = x.BildirimId,
                                          mesaj = x.Mesaj,
                                          tarih = x.Tarih,
                                          okunduMu = x.OkunduMu
                                      })
                                      .ToList();

            return Ok(bildirimler);
        }

        // 2. BİLDİRİM EKLE (Test için)
        // URL: api/Bildirimler/Ekle
        [HttpPost("Ekle")]
        public IActionResult Ekle([FromBody] Bildirimler yeniBildirim)
        {
            if (yeniBildirim == null) return BadRequest();

            // Tarih ve Okundu bilgisi boş gelirse biz dolduralım
            yeniBildirim.Tarih = DateTime.Now;
            yeniBildirim.OkunduMu = false;

            _context.Bildirimlers.Add(yeniBildirim);
            _context.SaveChanges();

            return Ok(new { message = "Bildirim başarıyla eklendi.", id = yeniBildirim.BildirimId });
        }

        // 3. BİLDİRİM SİL (İsteğe bağlı)
        // URL: api/Bildirimler/Sil/1
        [HttpDelete("Sil/{id}")]
        public IActionResult Sil(int id)
        {
            var bildirim = _context.Bildirimlers.FirstOrDefault(x => x.BildirimId == id);
            if (bildirim != null)
            {
                _context.Bildirimlers.Remove(bildirim);
                _context.SaveChanges();
                return Ok(new { message = "Silindi" });
            }
            return NotFound(new { message = "Bildirim bulunamadı" });
        }

        // =================================================================
        // 4. KULLANICIYA AİT TÜM BİLDİRİMLERİ SİL
        // Flutter'daki: tumBildirimleriSil() fonksiyonu buraya istek atar.
        // =================================================================
        [HttpDelete("TumuSil/{userId}")]
        public IActionResult TumuSil(int userId)
        {
            // 1. O kullanıcıya ait tüm bildirimleri bul
            var kullaniciBildirimleri = _context.Bildirimlers
                                                .Where(x => x.KullaniciId == userId)
                                                .ToList();

            // 2. Eğer bildirim varsa sil
            if (kullaniciBildirimleri.Any())
            {
                _context.Bildirimlers.RemoveRange(kullaniciBildirimleri);
                _context.SaveChanges(); // Değişiklikleri veritabanına işle
                return Ok(new { message = "Tüm bildirimler temizlendi." });
            }
            
            // 3. Zaten boşsa da hata verme, başarılı dön (Uygulama çökmesin)
            return Ok(new { message = "Zaten silinecek bildirim yok." });
        }
    }
}