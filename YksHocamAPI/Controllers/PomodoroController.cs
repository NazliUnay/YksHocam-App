using Microsoft.AspNetCore.Mvc;
using System;
using System.Linq;
using YksHocamAPI.Models;

namespace YksHocamAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PomodoroController : ControllerBase
    {
        private readonly YksHocamDbContext _context;

        public PomodoroController(YksHocamDbContext context)
        {
            _context = context;
        }

        // Yeni Oturum Ekleme (kaydetPomodoro ile uyumlu)
        [HttpPost("Ekle")]
        public IActionResult Ekle([FromBody] PomodoroOturumlari model)
        {
            if (model == null) return BadRequest("Veri boş.");

            if (model.Tarih == null)
            {
                model.Tarih = DateTime.Now;
            }

            _context.PomodoroOturumlaris.Add(model);
            _context.SaveChanges();

            return Ok(new
            {
                message = "Eklendi",
                id = model.OturumId,
                tarih = model.Tarih
            });
        }

        // Kullanıcının Tüm Pomodoro Geçmişini Getir (getPomodoroGecmisi ile uyumlu)
        [HttpGet("GetByUserId/{userId}")]
        public IActionResult GetByUserId(int userId)
        {
            var liste = _context.PomodoroOturumlaris
                .Where(x => x.KullaniciId == userId)
                .OrderByDescending(x => x.Tarih) // En yeni en üstte
                .ToList();

            return Ok(liste);
        }

        // BUGÜNÜN GEÇMİŞİ (getBugunPomodoroGecmisi metodu için gerekli olan kısım)
        [HttpGet("GetTodayByUserId/{userId}")]
        public IActionResult GetTodayByUserId(int userId)
        {
            var bugun = DateTime.Today; // Saat 00:00:00

            var liste = _context.PomodoroOturumlaris
                .Where(x => x.KullaniciId == userId && x.Tarih >= bugun)
                .OrderByDescending(x => x.Tarih)
                .ToList();

            return Ok(liste);
        }

        // Günlük İstatistik (getBugunToplamSure ile uyumlu)
        [HttpGet("GunlukOzet/{userId}")]
        public IActionResult GetGunlukOzet(int userId)
        {
            var bugun = DateTime.Today;
            var toplamDakika = _context.PomodoroOturumlaris
                .Where(x => x.KullaniciId == userId && x.Tarih >= bugun)
                .Sum(x => x.SureDakika ?? 0);

            return Ok(new { Tarih = bugun, ToplamDakika = toplamDakika });
        }

        // Oturum Silme (silPomodoro ile uyumlu)
        [HttpDelete("Sil/{id}")]
        public IActionResult Sil(int id)
        {
            var oturum = _context.PomodoroOturumlaris.Find(id);
            if (oturum == null) return NotFound("Oturum bulunamadı.");

            _context.PomodoroOturumlaris.Remove(oturum);
            _context.SaveChanges();

            return Ok(new { message = "Silindi" });
        }

        // Belirli bir tarihe göre filtreleme (Opsiyonel)
        [HttpGet("GetByUserIdAndDate/{userId}/{tarih}")]
        public IActionResult GetByUserIdAndDate(int userId, DateTime tarih)
        {
            var baslangic = tarih.Date;
            var bitis = baslangic.AddDays(1).AddTicks(-1);

            var liste = _context.PomodoroOturumlaris
                .Where(x => x.KullaniciId == userId && x.Tarih >= baslangic && x.Tarih <= bitis)
                .OrderByDescending(x => x.Tarih)
                .ToList();

            return Ok(liste);
        }
    }
}