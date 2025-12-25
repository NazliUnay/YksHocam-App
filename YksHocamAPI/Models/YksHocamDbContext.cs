using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

namespace YksHocamAPI.Models;

public partial class YksHocamDbContext : DbContext
{
    public YksHocamDbContext()
    {
    }

    public YksHocamDbContext(DbContextOptions<YksHocamDbContext> options)
        : base(options)
    {
    }

    public virtual DbSet<AliskanlikGunleri> AliskanlikGunleris { get; set; }

    public virtual DbSet<Aliskanliklar> Aliskanliklars { get; set; }

    public virtual DbSet<Bildirimler> Bildirimlers { get; set; }

    public virtual DbSet<Dersler> Derslers { get; set; }

    public virtual DbSet<Konular> Konulars { get; set; }

    public virtual DbSet<KullaniciKonuTakip> KullaniciKonuTakips { get; set; }

    public virtual DbSet<Kullanicilar> Kullanicilars { get; set; }

    public virtual DbSet<Notlar> Notlars { get; set; }

    public DbSet<OnemliGun> OnemliGunler { get; set; }

    public virtual DbSet<Planlar> Planlars { get; set; }

    public virtual DbSet<PomodoroOturumlari> PomodoroOturumlaris { get; set; }

    public virtual DbSet<Kullanicilar> Kullanicilar { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        => optionsBuilder.UseSqlServer("Server=NAZLI\\SQLEXPRESS;Database=YksHocamDB;Trusted_Connection=True;TrustServerCertificate=True;");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<AliskanlikGunleri>(entity =>
        {
            entity.HasKey(e => e.ZincirId).HasName("PK__Aliskanl__3E2FF6CEF98B9905");

            entity.ToTable("AliskanlikGunleri");

            entity.Property(e => e.Tarih)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");

            entity.HasOne(d => d.Aliskanlik).WithMany(p => p.AliskanlikGunleris)
                .HasForeignKey(d => d.AliskanlikId)
                .HasConstraintName("FK__Aliskanli__Alisk__66603565");
        });

        modelBuilder.Entity<Aliskanliklar>(entity =>
        {
            entity.HasKey(e => e.AliskanlikId).HasName("PK__Aliskanl__01DBA92A5DEE72FC");

            entity.ToTable("Aliskanliklar");

            entity.Property(e => e.Baslik).HasMaxLength(100);
            entity.Property(e => e.OlusturmaTarihi)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");

            entity.HasOne(d => d.Kullanici).WithMany(p => p.Aliskanliklars)
                .HasForeignKey(d => d.KullaniciId)
                .HasConstraintName("FK__Aliskanli__Kulla__628FA481");
        });

        modelBuilder.Entity<Bildirimler>(entity =>
        {
            entity.HasKey(e => e.BildirimId).HasName("PK__Bildirim__E778CE7E19021CF7");

            entity.ToTable("Bildirimler");

            entity.Property(e => e.Mesaj).HasMaxLength(255);
            entity.Property(e => e.OkunduMu).HasDefaultValue(false);
            entity.Property(e => e.Tarih)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");

            entity.HasOne(d => d.Kullanici).WithMany(p => p.Bildirimlers)
                .HasForeignKey(d => d.KullaniciId)
                .HasConstraintName("FK__Bildiriml__Kulla__6A30C649");
        });

        modelBuilder.Entity<Dersler>(entity =>
{
    entity.HasKey(e => e.DersId).HasName("PK__Dersler__E8B3DE110D318E04");
    entity.ToTable("Dersler");

    entity.Property(e => e.DersAdi).HasMaxLength(50);
    entity.Property(e => e.OgrenciAlan).HasMaxLength(20);

    // BURAYI EKLE:
    entity.Property(e => e.DersTip).HasMaxLength(10);
});

       modelBuilder.Entity<Konular>(entity =>
{
    entity.HasKey(e => e.KonuId).HasName("PK__Konular__DA4F3424AF48711A");
    entity.ToTable("Konular");

    entity.Property(e => e.KonuAdi).HasMaxLength(100);

    // DOĞRU TANIMLAMA: d.DersId nesne değil, d.Ders nesnedir.
    entity.HasOne(d => d.Ders) 
        .WithMany(p => p.Konulars)
        .HasForeignKey(d => d.DersId)
        .HasConstraintName("FK__Konular__DersId__4F7CD00D");
});
        modelBuilder.Entity<KullaniciKonuTakip>(entity =>
        {
            entity.HasKey(e => e.TakipId).HasName("PK__Kullanic__B19E07C7104A81B6");

            entity.ToTable("KullaniciKonuTakip");

            entity.Property(e => e.TamamlandiMi).HasDefaultValue(false);
            entity.Property(e => e.TamamlanmaTarihi).HasColumnType("datetime");

            entity.HasOne(d => d.Konu).WithMany(p => p.KullaniciKonuTakips)
                .HasForeignKey(d => d.KonuId)
                .HasConstraintName("FK__Kullanici__KonuI__534D60F1");

            entity.HasOne(d => d.Kullanici).WithMany(p => p.KullaniciKonuTakips)
                .HasForeignKey(d => d.KullaniciId)
                .HasConstraintName("FK__Kullanici__Kulla__52593CB8");
        });

        modelBuilder.Entity<Kullanicilar>(entity =>
        {
            entity.HasKey(e => e.KullaniciId).HasName("PK__Kullanic__E011F77B5ED1E05D");

            entity.ToTable("Kullanicilar");

            entity.HasIndex(e => e.Email, "UQ__Kullanic__A9D10534DC669315").IsUnique();

            entity.Property(e => e.AdSoyad).HasMaxLength(100);
            entity.Property(e => e.Alan).HasMaxLength(50);
            entity.Property(e => e.Email).HasMaxLength(100);
            entity.Property(e => e.KayitTarihi)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.Sifre).HasMaxLength(255);
        });

        modelBuilder.Entity<Notlar>(entity =>
        {
            entity.HasKey(e => e.NotId).HasName("PK__Notlar__4FB2008A456175B3");

            entity.ToTable("Notlar");

            entity.Property(e => e.Baslik).HasMaxLength(100);
            entity.Property(e => e.Kategori).HasMaxLength(50);
            entity.Property(e => e.OlusturmaTarihi)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");

            entity.HasOne(d => d.Kullanici).WithMany(p => p.Notlars)
                .HasForeignKey(d => d.KullaniciId)
                .HasConstraintName("FK__Notlar__Kullanic__571DF1D5");
        });

        modelBuilder.Entity<Planlar>(entity =>
        {
            entity.HasKey(e => e.PlanId).HasName("PK__Planlar__755C22B744332759");

            entity.ToTable("Planlar");

            entity.Property(e => e.Baslik).HasMaxLength(200);
            entity.Property(e => e.Durum).HasDefaultValue(false);
            entity.Property(e => e.Tarih).HasColumnType("datetime");

            entity.HasOne(d => d.Kullanici).WithMany(p => p.Planlars)
                .HasForeignKey(d => d.KullaniciId)
                .HasConstraintName("FK__Planlar__Kullani__5AEE82B9");
        });

        modelBuilder.Entity<PomodoroOturumlari>(entity =>
        {
            entity.HasKey(e => e.OturumId).HasName("PK__Pomodoro__59AA116D48698A6B");

            entity.ToTable("PomodoroOturumlari");

            entity.Property(e => e.CalisilanKonu).HasMaxLength(100);
            entity.Property(e => e.Tarih)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");

            entity.HasOne(d => d.Kullanici).WithMany(p => p.PomodoroOturumlaris)
                .HasForeignKey(d => d.KullaniciId)
                .HasConstraintName("FK__PomodoroO__Kulla__5EBF139D");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
