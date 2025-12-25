using System;
using System.Collections.Generic;

namespace YksHocamAPI.Models;

public partial class Bildirimler
{
    public int BildirimId { get; set; }

    public int? KullaniciId { get; set; }

    public string? Mesaj { get; set; }

    public DateTime? Tarih { get; set; }

    public bool? OkunduMu { get; set; }

    public virtual Kullanicilar? Kullanici { get; set; }
}
