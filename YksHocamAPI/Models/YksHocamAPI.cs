namespace YksHocamAPI.Models
{
    public class KonuDto
    {
        public int Id { get; set; }
        public string Ad { get; set; }
        public bool TamamlandiMi { get; set; }
        public string? TamamlanmaTarihi { get; set; }
    }

    public class KonuDurumGuncelleDto
    {
        public int KonuId { get; set; }
        public int KullaniciId { get; set; } // Hangi öğrenci?
        public bool Durum { get; set; }
    }
}