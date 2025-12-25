using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.EntityFrameworkCore;
using System;
using System.Threading;
using System.Threading.Tasks;
using YksHocamAPI.Models; // Namespace'ini kontrol et

namespace YksHocamAPI.Services
{
    public class GunlukBildirimService : BackgroundService
    {
        private readonly IServiceScopeFactory _scopeFactory;
        
        // Bayraklar: Aynı gün içinde tekrar mesaj atmasın diye
        private bool _sabahAtildi = false;
        private bool _aksamAtildi = false;
        private readonly DateTime _yksTarihi = new DateTime(2026, 6, 15);

        public GunlukBildirimService(IServiceScopeFactory scopeFactory)
        {
            _scopeFactory = scopeFactory;
        }

        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {
            while (!stoppingToken.IsCancellationRequested)
            {
                var simdi = DateTime.Now;

                // SABAH 08:00 (GERİ SAYIM) ---
                if (simdi.Hour == 8  && !_sabahAtildi)
                {
                    // Kalan günü hesapla
                    var kalanGun = (_yksTarihi - simdi).Days;
                    string mesaj = $"Günaydın! ☀️ Sınava {kalanGun} gün kaldı. Bugünün planı hazır mı?";
                    
                    await TopluBildirimGonder(mesaj);
                    _sabahAtildi = true; 
                    Console.WriteLine($"[Bildirim] Sabah mesajı gönderildi: {mesaj}");
                }

                // AKŞAM 22:00 (VERİ GİRİŞİ HATIRLATMA) ---
                if (simdi.Hour == 22 && !_aksamAtildi)
                {
                    string mesaj = "Günün bitti! 🌙 Bugün çok iyi çalıştın.";
                    
                    await TopluBildirimGonder(mesaj);
                    _aksamAtildi = true;
                    Console.WriteLine("[Bildirim] Akşam hatırlatması gönderildi.");
                }

                // GECE YARISI (SIFIRLAMA)
                // Yeni güne geçtiğimizde bayrakları indiriyoruz ki yarın tekrar atabilsin.
                if (simdi.Hour == 0 && simdi.Minute == 0)
                {
                    _sabahAtildi = false;
                    _aksamAtildi = false;
                }

                // Her 1 dakikada bir saati kontrol et
                await Task.Delay(TimeSpan.FromMinutes(1), stoppingToken);
            }
        }

        // Yardımcı Fonksiyon: SQL Prosedürünü Çağırır
        private async Task TopluBildirimGonder(string mesaj)
        {
            try
            {
                using (var scope = _scopeFactory.CreateScope())
                {
                    var context = scope.ServiceProvider.GetRequiredService<YksHocamDbContext>();
                    // SQL'deki sp_TopluBildirimEkle prosedürünü çağırır
                    await context.Database.ExecuteSqlRawAsync("EXEC sp_TopluBildirimEkle {0}", mesaj);
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Hata: {ex.Message}");
            }
        }
    }
}