using System;
using System.Collections.Generic;

namespace YksHocamAPI.Models;

public partial class AliskanlikGunleri
{
    public int ZincirId { get; set; }

    public int? AliskanlikId { get; set; }

    public DateTime? Tarih { get; set; }

    public virtual Aliskanliklar? Aliskanlik { get; set; }
}
