using Microsoft.EntityFrameworkCore;
using YksHocamAPI.Models;
using YksHocamAPI.Services; 

var builder = WebApplication.CreateBuilder(args);

// --- 1. SERVİSLERİ EKLEME BÖLÜMÜ (Builder Kısmı) ---

builder.Services.AddControllers(); 
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// Veritabanı Bağlantısını Ekle
builder.Services.AddDbContext<YksHocamDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

// Arka plan servisi
builder.Services.AddHostedService<GunlukBildirimService>();

// --- DÜZELTME: BUILDER'DAN ÖNCE OLMALI ---
builder.Services.Configure<IISServerOptions>(options =>
{
    options.MaxRequestBodySize = 104857600; // 100 MB
});

builder.Services.Configure<Microsoft.AspNetCore.Http.Features.FormOptions>(options =>
{
    options.MultipartBodyLengthLimit = 104857600; // 100 MB
});
// ----------------------------------------

// 2. UYGULAMAYI İNŞA ET (Kilitleme noktası)
var app = builder.Build();

// --- 3. AYARLAR VE ÇALIŞTIRMA BÖLÜMÜ (App Kısmı) ---

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();
app.UseAuthorization();

// Controller'ları eşleştir
app.MapControllers(); 

// Uygulamayı başlat
app.Run();