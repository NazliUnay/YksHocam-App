using System;
using System.Collections.Generic;

namespace YksHocamAPI.Models;

public partial class Notlar
{
    public int NotId { get; set; }

    public int? KullaniciId { get; set; }

    public string? Baslik { get; set; }

    public string? Icerik { get; set; }

    public string? Kategori { get; set; }

    public DateTime? OlusturmaTarihi { get; set; }

    public string? Alan { get; set; }   // TYT veya AYT

    public virtual Kullanicilar? Kullanici { get; set; }
}
