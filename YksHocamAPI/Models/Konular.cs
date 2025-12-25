using System;
using System.Collections.Generic;

namespace YksHocamAPI.Models;

public partial class Konular
{
    public int KonuId { get; set; }

    public int? DersId { get; set; }

    public string KonuAdi { get; set; } = null!;
    
    public virtual Dersler? Ders { get; set; }

    public virtual ICollection<KullaniciKonuTakip> KullaniciKonuTakips { get; set; } = new List<KullaniciKonuTakip>();
}
