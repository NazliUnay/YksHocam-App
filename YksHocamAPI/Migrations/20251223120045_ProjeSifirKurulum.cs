using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace YksHocamAPI.Migrations
{
    /// <inheritdoc />
    public partial class ProjeSifirKurulum : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Dersler",
                columns: table => new
                {
                    DersId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    DersAdi = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    OgrenciAlan = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: true),
                    DersTip = table.Column<string>(type: "nvarchar(10)", maxLength: 10, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Dersler__E8B3DE110D318E04", x => x.DersId);
                });

            migrationBuilder.CreateTable(
                name: "Kullanicilar",
                columns: table => new
                {
                    KullaniciId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    AdSoyad = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    Email = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    Sifre = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: false),
                    Alan = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true),
                    ProfilFotoUrl = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    KayitTarihi = table.Column<DateTime>(type: "datetime", nullable: true, defaultValueSql: "(getdate())")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Kullanic__E011F77B5ED1E05D", x => x.KullaniciId);
                });

            migrationBuilder.CreateTable(
                name: "OnemliGunler",
                columns: table => new
                {
                    OnemliGunId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    KullaniciId = table.Column<int>(type: "int", nullable: false),
                    Baslik = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Tarih = table.Column<DateTime>(type: "datetime2", nullable: false),
                    RenkKodu = table.Column<string>(type: "nvarchar(max)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_OnemliGunler", x => x.OnemliGunId);
                });

            migrationBuilder.CreateTable(
                name: "Konular",
                columns: table => new
                {
                    KonuId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    DersId = table.Column<int>(type: "int", nullable: true),
                    KonuAdi = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Konular__DA4F3424AF48711A", x => x.KonuId);
                    table.ForeignKey(
                        name: "FK__Konular__DersId__4F7CD00D",
                        column: x => x.DersId,
                        principalTable: "Dersler",
                        principalColumn: "DersId");
                });

            migrationBuilder.CreateTable(
                name: "Aliskanliklar",
                columns: table => new
                {
                    AliskanlikId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    KullaniciId = table.Column<int>(type: "int", nullable: true),
                    Baslik = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    OlusturmaTarihi = table.Column<DateTime>(type: "datetime", nullable: true, defaultValueSql: "(getdate())")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Aliskanl__01DBA92A5DEE72FC", x => x.AliskanlikId);
                    table.ForeignKey(
                        name: "FK__Aliskanli__Kulla__628FA481",
                        column: x => x.KullaniciId,
                        principalTable: "Kullanicilar",
                        principalColumn: "KullaniciId");
                });

            migrationBuilder.CreateTable(
                name: "Bildirimler",
                columns: table => new
                {
                    BildirimId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    KullaniciId = table.Column<int>(type: "int", nullable: true),
                    Mesaj = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: true),
                    Tarih = table.Column<DateTime>(type: "datetime", nullable: true, defaultValueSql: "(getdate())"),
                    OkunduMu = table.Column<bool>(type: "bit", nullable: true, defaultValue: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Bildirim__E778CE7E19021CF7", x => x.BildirimId);
                    table.ForeignKey(
                        name: "FK__Bildiriml__Kulla__6A30C649",
                        column: x => x.KullaniciId,
                        principalTable: "Kullanicilar",
                        principalColumn: "KullaniciId");
                });

            migrationBuilder.CreateTable(
                name: "Notlar",
                columns: table => new
                {
                    NotId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    KullaniciId = table.Column<int>(type: "int", nullable: true),
                    Baslik = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: true),
                    Icerik = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Kategori = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true),
                    OlusturmaTarihi = table.Column<DateTime>(type: "datetime", nullable: true, defaultValueSql: "(getdate())"),
                    Alan = table.Column<string>(type: "nvarchar(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Notlar__4FB2008A456175B3", x => x.NotId);
                    table.ForeignKey(
                        name: "FK__Notlar__Kullanic__571DF1D5",
                        column: x => x.KullaniciId,
                        principalTable: "Kullanicilar",
                        principalColumn: "KullaniciId");
                });

            migrationBuilder.CreateTable(
                name: "Planlar",
                columns: table => new
                {
                    PlanId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    KullaniciId = table.Column<int>(type: "int", nullable: true),
                    Baslik = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: false),
                    Aciklama = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Saat = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Tarih = table.Column<DateTime>(type: "datetime", nullable: false),
                    Durum = table.Column<bool>(type: "bit", nullable: true, defaultValue: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Planlar__755C22B744332759", x => x.PlanId);
                    table.ForeignKey(
                        name: "FK__Planlar__Kullani__5AEE82B9",
                        column: x => x.KullaniciId,
                        principalTable: "Kullanicilar",
                        principalColumn: "KullaniciId");
                });

            migrationBuilder.CreateTable(
                name: "PomodoroOturumlari",
                columns: table => new
                {
                    OturumId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    KullaniciId = table.Column<int>(type: "int", nullable: true),
                    CalisilanKonu = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: true),
                    SureDakika = table.Column<int>(type: "int", nullable: true),
                    Tarih = table.Column<DateTime>(type: "datetime", nullable: true, defaultValueSql: "(getdate())")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Pomodoro__59AA116D48698A6B", x => x.OturumId);
                    table.ForeignKey(
                        name: "FK__PomodoroO__Kulla__5EBF139D",
                        column: x => x.KullaniciId,
                        principalTable: "Kullanicilar",
                        principalColumn: "KullaniciId");
                });

            migrationBuilder.CreateTable(
                name: "KullaniciKonuTakip",
                columns: table => new
                {
                    TakipId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    KullaniciId = table.Column<int>(type: "int", nullable: true),
                    KonuId = table.Column<int>(type: "int", nullable: true),
                    TamamlandiMi = table.Column<bool>(type: "bit", nullable: true, defaultValue: false),
                    TamamlanmaTarihi = table.Column<DateTime>(type: "datetime", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Kullanic__B19E07C7104A81B6", x => x.TakipId);
                    table.ForeignKey(
                        name: "FK__Kullanici__KonuI__534D60F1",
                        column: x => x.KonuId,
                        principalTable: "Konular",
                        principalColumn: "KonuId");
                    table.ForeignKey(
                        name: "FK__Kullanici__Kulla__52593CB8",
                        column: x => x.KullaniciId,
                        principalTable: "Kullanicilar",
                        principalColumn: "KullaniciId");
                });

            migrationBuilder.CreateTable(
                name: "AliskanlikGunleri",
                columns: table => new
                {
                    ZincirId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    AliskanlikId = table.Column<int>(type: "int", nullable: true),
                    Tarih = table.Column<DateTime>(type: "datetime", nullable: true, defaultValueSql: "(getdate())")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Aliskanl__3E2FF6CEF98B9905", x => x.ZincirId);
                    table.ForeignKey(
                        name: "FK__Aliskanli__Alisk__66603565",
                        column: x => x.AliskanlikId,
                        principalTable: "Aliskanliklar",
                        principalColumn: "AliskanlikId");
                });

            migrationBuilder.CreateIndex(
                name: "IX_AliskanlikGunleri_AliskanlikId",
                table: "AliskanlikGunleri",
                column: "AliskanlikId");

            migrationBuilder.CreateIndex(
                name: "IX_Aliskanliklar_KullaniciId",
                table: "Aliskanliklar",
                column: "KullaniciId");

            migrationBuilder.CreateIndex(
                name: "IX_Bildirimler_KullaniciId",
                table: "Bildirimler",
                column: "KullaniciId");

            migrationBuilder.CreateIndex(
                name: "IX_Konular_DersId",
                table: "Konular",
                column: "DersId");

            migrationBuilder.CreateIndex(
                name: "IX_KullaniciKonuTakip_KonuId",
                table: "KullaniciKonuTakip",
                column: "KonuId");

            migrationBuilder.CreateIndex(
                name: "IX_KullaniciKonuTakip_KullaniciId",
                table: "KullaniciKonuTakip",
                column: "KullaniciId");

            migrationBuilder.CreateIndex(
                name: "UQ__Kullanic__A9D10534DC669315",
                table: "Kullanicilar",
                column: "Email",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Notlar_KullaniciId",
                table: "Notlar",
                column: "KullaniciId");

            migrationBuilder.CreateIndex(
                name: "IX_Planlar_KullaniciId",
                table: "Planlar",
                column: "KullaniciId");

            migrationBuilder.CreateIndex(
                name: "IX_PomodoroOturumlari_KullaniciId",
                table: "PomodoroOturumlari",
                column: "KullaniciId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "AliskanlikGunleri");

            migrationBuilder.DropTable(
                name: "Bildirimler");

            migrationBuilder.DropTable(
                name: "KullaniciKonuTakip");

            migrationBuilder.DropTable(
                name: "Notlar");

            migrationBuilder.DropTable(
                name: "OnemliGunler");

            migrationBuilder.DropTable(
                name: "Planlar");

            migrationBuilder.DropTable(
                name: "PomodoroOturumlari");

            migrationBuilder.DropTable(
                name: "Aliskanliklar");

            migrationBuilder.DropTable(
                name: "Konular");

            migrationBuilder.DropTable(
                name: "Kullanicilar");

            migrationBuilder.DropTable(
                name: "Dersler");
        }
    }
}
