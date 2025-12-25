using System;
using System.Collections.Generic;

namespace YksHocamAPI.Models;

public partial class KullaniciKonuTakip
{
    public int TakipId { get; set; }

    public int? KullaniciId { get; set; }

    public int? KonuId { get; set; }

    public bool? TamamlandiMi { get; set; }

    public DateTime? TamamlanmaTarihi { get; set; }

    public virtual Konular? Konu { get; set; }

    public virtual Kullanicilar? Kullanici { get; set; }
}
