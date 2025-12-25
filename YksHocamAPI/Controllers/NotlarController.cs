using Microsoft.AspNetCore.Mvc;
using YksHocamAPI.Models;
using System.Linq;
using System;

namespace YksHocamAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class NotlarController : ControllerBase
    {
        private readonly YksHocamDbContext _context;

        public NotlarController(YksHocamDbContext context)
        {
            _context = context;
        }

        [HttpGet("GetByKategori/{userId}")]
        public IActionResult GetByKategori(int userId, [FromQuery] string kategori)
        {
            // Renk ve SabitMi yok, sadece tarih sırasına göre listeleme var
            var notlar = _context.Notlars
                .Where(x => x.KullaniciId == userId && x.Kategori == kategori)
                .OrderByDescending(x => x.OlusturmaTarihi)
                .ToList();

            return Ok(notlar);
        }

        [HttpPost("Ekle")]
        public IActionResult Ekle([FromBody] Notlar yeniNot)
        {
            yeniNot.OlusturmaTarihi = DateTime.Now;
            
            _context.Notlars.Add(yeniNot);
            _context.SaveChanges();
            
            return Ok(new { message = "Eklendi", id = yeniNot.NotId });
        }

        [HttpDelete("Sil/{id}")]
        public IActionResult Sil(int id)
        {
            var not = _context.Notlars.FirstOrDefault(x => x.NotId == id);
            if (not != null)
            {
                _context.Notlars.Remove(not);
                _context.SaveChanges();
                return Ok(new { message = "Silindi" });
            }
            return NotFound();
        }
    }
}