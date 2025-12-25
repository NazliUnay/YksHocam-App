using System;
using System.Collections.Generic;

namespace YksHocamAPI.Models;

public partial class Aliskanliklar
{
    public int AliskanlikId { get; set; }

    public int? KullaniciId { get; set; }

    public string Baslik { get; set; } = null!;

    public DateTime? OlusturmaTarihi { get; set; }

    public virtual ICollection<AliskanlikGunleri> AliskanlikGunleris { get; set; } = new List<AliskanlikGunleri>();

    public virtual Kullanicilar? Kullanici { get; set; }
}
