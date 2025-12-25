using Microsoft.AspNetCore.Mvc;
using YksHocamAPI.Models;
using System.Linq;
using System;

namespace YksHocamAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PlanlarController : ControllerBase
    {
        private readonly YksHocamDbContext _context;

        public PlanlarController(YksHocamDbContext context)
        {
            _context = context;
        }

        // TARİHE GÖRE GETİR
        [HttpGet("GetByDate/{userId}")]
        public IActionResult GetByDate(int userId, [FromQuery] string tarih) // DateTime yerine string aldık
        {
            try
            {
                // 1. Gelen string tarihi parse et (Hata payını azaltır)
                if (!DateTime.TryParse(tarih, out DateTime parsedDate))
                {
                    return BadRequest(new { message = "Geçersiz tarih formatı." });
                }

                // 2. Filtreleme: Saat, dakika, saniyeyi görmezden gelip sadece Yıl-Ay-Gün karşılaştır
                var planlar = _context.Planlars
                    .Where(p => p.KullaniciId == userId)
                    .ToList() // Veriyi belleğe çek (Bazen SQL Provider .Date'i desteklemez)
                    .Where(p => p.Tarih.Date == parsedDate.Date)
                    .OrderBy(p => p.Saat)
                    .Select(p => new
                    {
                        planId = p.PlanId,
                        baslik = p.Baslik,
                        saat = p.Saat,
                        durum = p.Durum ?? false,
                        tarih = p.Tarih.ToString("yyyy-MM-ddTHH:mm:ss")
                    })
                    .ToList();

                // Konsola log yaz (Hata ayıklamak için API ekranında görünecek)
                Console.WriteLine($"İstek: User:{userId} Tarih:{parsedDate.ToShortDateString()} Bulunan:{planlar.Count}");

                return Ok(planlar);
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { error = ex.Message });
            }
        }

        // EKLE
        [HttpPost("Ekle")]
        public IActionResult Ekle([FromBody] Planlar yeniPlan)
        {
            if (!ModelState.IsValid) return BadRequest(ModelState);

            try
            {
                if (yeniPlan.KullaniciId == 0)
                    return BadRequest(new { message = "KullaniciId eksik!" });

                // Model eşleşmesi (JsonPropertyName sayesinde Dart'tan gelen veriler dolacak)
                _context.Planlars.Add(yeniPlan);
                _context.SaveChanges();

                return Ok(new { message = "Eklendi", id = yeniPlan.PlanId });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { error = "Hata: " + ex.Message });
            }
        }

        // GÜNCELLE
        [HttpPut("Guncelle")]
        public IActionResult Guncelle([FromBody] Planlar plan)
        {
            var mevcut = _context.Planlars.FirstOrDefault(x => x.PlanId == plan.PlanId);

            if (mevcut != null)
            {
                mevcut.Baslik = plan.Baslik;
                mevcut.Saat = plan.Saat;
                mevcut.Durum = plan.Durum ?? false;

                _context.SaveChanges();
                return Ok(new { message = "Güncellendi" });
            }
            return NotFound();
        }

        // SİL
        [HttpDelete("Sil/{id}")]
        public IActionResult Sil(int id)
        {
            var plan = _context.Planlars.FirstOrDefault(x => x.PlanId == id);
            if (plan != null)
            {
                _context.Planlars.Remove(plan);
                _context.SaveChanges();
                return Ok(new { message = "Silindi" });
            }
            return NotFound();
        }
    }
}