using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace YksHocamAPI.Models
{
    public class Planlar
    {
        [Key]
        public int PlanId { get; set; }

        public int? KullaniciId { get; set; }
        public string Baslik { get; set; } = null!;
        public string? Saat { get; set; }
        public DateTime Tarih { get; set; }
        public bool? Durum { get; set; }
        
        [ForeignKey("KullaniciId")]
        public virtual Kullanicilar? Kullanici { get; set; }
    }
}