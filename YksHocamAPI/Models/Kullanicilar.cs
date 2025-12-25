using System;
using System.Collections.Generic;

namespace YksHocamAPI.Models;

public partial class Kullanicilar
{
    public int KullaniciId { get; set; }

    public string AdSoyad { get; set; } = null!;

    public string Email { get; set; } = null!;

    public string Sifre { get; set; } = null!;

    public string? Alan { get; set; }

    public string? ProfilFotoUrl { get; set; }

    public DateTime? KayitTarihi { get; set; }

    public virtual ICollection<Aliskanliklar> Aliskanliklars { get; set; } = new List<Aliskanliklar>();

    public virtual ICollection<Bildirimler> Bildirimlers { get; set; } = new List<Bildirimler>();

    public virtual ICollection<KullaniciKonuTakip> KullaniciKonuTakips { get; set; } = new List<KullaniciKonuTakip>();

    public virtual ICollection<Notlar> Notlars { get; set; } = new List<Notlar>();

    public virtual ICollection<Planlar> Planlars { get; set; } = new List<Planlar>();

    public virtual ICollection<PomodoroOturumlari> PomodoroOturumlaris { get; set; } = new List<PomodoroOturumlari>();
}
