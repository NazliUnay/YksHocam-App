using Microsoft.AspNetCore.Mvc;
using YksHocamAPI.Models;
using System.Linq;
using System;

namespace YksHocamAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class KonularController : ControllerBase
    {
        private readonly YksHocamDbContext _context;

        public KonularController(YksHocamDbContext context)
        {
            _context = context;
        }

        // Konulara getir
        [HttpGet("GetByDers/{userId}")]
        public IActionResult GetByDers(int userId, [FromQuery] string alan, [FromQuery] string ders)
        {
            // Veritabanındaki Dersler tablosuna erişiyoruz
            var hedefDers = _context.Derslers.FirstOrDefault(d =>
                d.DersAdi.Trim().ToLower() == ders.Trim().ToLower() &&
                d.DersTip.Trim().ToLower() == alan.Trim().ToLower());

            if (hedefDers == null)
            {
                return NotFound(new { message = $"Ders bulunamadı: {ders} ({alan})" });
            }

            var sonuc = _context.Konulars
                .Where(k => k.DersId == hedefDers.DersId)
                .Select(k => new
                {
                    id = k.KonuId,
                    ad = k.KonuAdi,
                    // Kullanıcının bu konuyu tamamlayıp tamamlamadığını kontrol et
                    tamamlandiMi = k.KullaniciKonuTakips
                                    .Any(t => t.KullaniciId == userId && t.TamamlandiMi == true),
                    tamamlanmaTarihi = k.KullaniciKonuTakips
                                        .Where(t => t.KullaniciId == userId && t.TamamlandiMi == true)
                                        .Select(t => t.TamamlanmaTarihi)
                                        .FirstOrDefault()
                })
                .ToList();

            return Ok(sonuc);
        }

        // Konu bittiğinde tik atma işlemi
        [HttpPost("DurumGuncelle")]
        public IActionResult DurumGuncelle([FromBody] KullaniciKonuTakip takipVerisi)
        {
            bool gelenDurum = takipVerisi.TamamlandiMi ?? false;

            var mevcutKayit = _context.KullaniciKonuTakips
                .FirstOrDefault(x => x.KullaniciId == takipVerisi.KullaniciId && x.KonuId == takipVerisi.KonuId);

            if (mevcutKayit == null)
            {
                // Kayıt yoksa yeni ekle
                takipVerisi.TamamlandiMi = gelenDurum;
                takipVerisi.TamamlanmaTarihi = gelenDurum ? DateTime.Now : null;
                _context.KullaniciKonuTakips.Add(takipVerisi);
            }
            else
            {
                // Kayıt varsa güncelle
                mevcutKayit.TamamlandiMi = gelenDurum;
                mevcutKayit.TamamlanmaTarihi = gelenDurum ? DateTime.Now : null;
            }

            _context.SaveChanges();
            return Ok(new { message = "Durum başarıyla güncellendi" });
        }
    }
}