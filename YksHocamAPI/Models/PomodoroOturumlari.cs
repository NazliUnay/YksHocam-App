using System;
using System.Collections.Generic;

namespace YksHocamAPI.Models;

public partial class PomodoroOturumlari
{
    public int OturumId { get; set; }

    public int? KullaniciId { get; set; }

    public string? CalisilanKonu { get; set; }

    public int? SureDakika { get; set; }

    public DateTime? Tarih { get; set; }

    public virtual Kullanicilar? Kullanici { get; set; }
}
