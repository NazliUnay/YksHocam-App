using System;
using System.Collections.Generic;

namespace YksHocamAPI.Models;

public partial class Dersler
{
    public int DersId { get; set; }

    public string DersAdi { get; set; } = null!;

    public string? OgrenciAlan { get; set; }
    public string? DersTip { get; set; } 
    public virtual ICollection<Konular> Konulars { get; set; } = new List<Konular>();
}
