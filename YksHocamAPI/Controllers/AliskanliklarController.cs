using Microsoft.AspNetCore.Mvc;
using System;
using System.Linq;
using YksHocamAPI.Models;

namespace YksHocamAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AliskanliklarController : ControllerBase
    {
        private readonly YksHocamDbContext _context;

        public AliskanliklarController(YksHocamDbContext context)
        {
            _context = context;
        }

        // 1. Yeni Alışkanlık Ekleme
        [HttpPost("Ekle")]
        public IActionResult Ekle([FromBody] Aliskanliklar model)
        {
            if (model == null) return BadRequest("Veri boş.");
            model.OlusturmaTarihi = DateTime.Now;
            _context.Aliskanliklars.Add(model);
            _context.SaveChanges();
            return Ok(model);
        }

        // 2. Kullanıcıya Göre Listeleme
        [HttpGet("GetByUserId/{userId}")]
        public IActionResult GetByUserId(int userId)
        {
            var liste = _context.Aliskanliklars
                .Where(x => x.KullaniciId == userId)
                .OrderByDescending(x => x.AliskanlikId)
                .ToList();
            return Ok(liste);
        }

        // 3. Ay içindeki işaretli günleri getir
        [HttpGet("GetirGunler/{aliskanlikId}/{yil}/{ay}")]
        public IActionResult GetirGunler(int aliskanlikId, int yil, int ay)
        {
            var doluGunler = _context.AliskanlikGunleris
                .Where(x => x.AliskanlikId == aliskanlikId &&
                            x.Tarih.Value.Year == yil &&
                            x.Tarih.Value.Month == ay)
                .Select(x => x.Tarih.Value.Day)
                .ToList();

            return Ok(doluGunler);
        }

        // 4. Gün İşaretleme (Toggle)
        [HttpPost("GunIsaretle")]
        public IActionResult GunIsaretle([FromBody] GunIsaretleRequest request)
        {
            if (request == null) return BadRequest("Veri gelmedi.");
            var mevcutKayit = _context.AliskanlikGunleris
                .FirstOrDefault(x => x.AliskanlikId == request.AliskanlikId && x.Tarih == request.Tarih);

            if (mevcutKayit != null) {
                _context.AliskanlikGunleris.Remove(mevcutKayit);
                _context.SaveChanges();
                return Ok(new { Durum = "Silindi" });
            } else {
                var yeniKayit = new AliskanlikGunleri { AliskanlikId = request.AliskanlikId, Tarih = request.Tarih };
                _context.AliskanlikGunleris.Add(yeniKayit);
                _context.SaveChanges();
                return Ok(new { Durum = "Eklendi" });
            }
        }

        // 5. Alışkanlık Silme
        [HttpDelete("Sil/{id}")]
        public IActionResult Sil(int id)
        {
            var aliskanlik = _context.Aliskanliklars.Find(id);
            if (aliskanlik == null) return NotFound();
            var bagliGunler = _context.AliskanlikGunleris.Where(x => x.AliskanlikId == id);
            _context.AliskanlikGunleris.RemoveRange(bagliGunler);
            _context.Aliskanliklars.Remove(aliskanlik);
            _context.SaveChanges();
            return Ok();
        }
    }

    public class GunIsaretleRequest {
        public int AliskanlikId { get; set; }
        public DateTime Tarih { get; set; }
    }
}