using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using YksHocamAPI.Models;

namespace YksHocamAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class OnemliGunlerController : ControllerBase
    {
        private readonly YksHocamDbContext _context;

        public OnemliGunlerController(YksHocamDbContext context)
        {
            _context = context;
        }

        // Listeleme
        [HttpGet("Getir/{kullaniciId}/{yil}/{ay}")]
        public IActionResult GetOnemliGunler(int kullaniciId, int yil, int ay)
        {
            var baslangic = new DateTime(yil, ay, 1);
            var bitis = baslangic.AddMonths(1);

            var liste = _context.OnemliGunler
                .Where(x =>
                    x.KullaniciId == kullaniciId &&
                    x.Tarih >= baslangic &&
                    x.Tarih < bitis)
                .OrderBy(x => x.Tarih)
                .ToList();
            System.Diagnostics.Debug.WriteLine($"Sorgu Parametreleri: User:{kullaniciId}, Yil:{yil}, Ay:{ay}. Bulunan Kayıt: {liste.Count}");
            return Ok(liste);
        }


        // Yeni Önemli Gün Ekleme
        [HttpPost("Ekle")]
        public IActionResult Ekle([FromBody] OnemliGun yeniGun)
        {
            if (yeniGun == null) return BadRequest("Veri boş.");

            try
            {
                _context.OnemliGunler.Add(yeniGun);
                _context.SaveChanges();

                return Ok(new { message = "Eklendi", id = yeniGun.OnemliGunId });
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = "Veritabanı hatası: " + ex.InnerException?.Message ?? ex.Message });
            }
        }

        // Silme İşlemi
        [HttpDelete("Sil/{id}")]
        public IActionResult Sil(int id)
        {
            var onemliGun = _context.OnemliGunler.Find(id);
            if (onemliGun == null) return NotFound();

            _context.OnemliGunler.Remove(onemliGun);
            _context.SaveChanges();

            return Ok(new { message = "Silindi" });
        }
    }
}