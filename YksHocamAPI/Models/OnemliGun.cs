using System.ComponentModel.DataAnnotations;

namespace YksHocamAPI.Models
{
    public class OnemliGun
    {
        [Key]
        public int OnemliGunId { get; set; }
        public int KullaniciId { get; set; }
        public string Baslik { get; set; }
        public DateTime Tarih { get; set; }
    }
}