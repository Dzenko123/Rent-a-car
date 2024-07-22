using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace RentACar.Services.Migrations
{
    public partial class druga : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_VoziloPregled_Vozila_VoziloId",
                table: "VoziloPregled");

            migrationBuilder.UpdateData(
                table: "KorisniciUloge",
                keyColumn: "KorisnikUlogaId",
                keyValue: 1,
                column: "DatumIzmjene",
                value: new DateTime(2024, 7, 10, 11, 12, 2, 590, DateTimeKind.Local).AddTicks(3379));

            migrationBuilder.UpdateData(
                table: "KorisniciUloge",
                keyColumn: "KorisnikUlogaId",
                keyValue: 2,
                column: "DatumIzmjene",
                value: new DateTime(2024, 7, 10, 11, 12, 2, 590, DateTimeKind.Local).AddTicks(3430));

            migrationBuilder.UpdateData(
                table: "KorisniciUloge",
                keyColumn: "KorisnikUlogaId",
                keyValue: 3,
                column: "DatumIzmjene",
                value: new DateTime(2024, 7, 10, 11, 12, 2, 590, DateTimeKind.Local).AddTicks(3434));

            migrationBuilder.UpdateData(
                table: "Rezervacija",
                keyColumn: "RezervacijaId",
                keyValue: 1,
                columns: new[] { "PocetniDatum", "ZavrsniDatum" },
                values: new object[] { new DateTime(2024, 7, 14, 11, 12, 0, 991, DateTimeKind.Local).AddTicks(9494), new DateTime(2024, 7, 16, 11, 12, 0, 997, DateTimeKind.Local).AddTicks(6354) });

            migrationBuilder.UpdateData(
                table: "Rezervacija",
                keyColumn: "RezervacijaId",
                keyValue: 2,
                columns: new[] { "PocetniDatum", "ZavrsniDatum" },
                values: new object[] { new DateTime(2024, 7, 14, 11, 12, 0, 991, DateTimeKind.Local).AddTicks(9494), new DateTime(2024, 7, 16, 11, 12, 0, 997, DateTimeKind.Local).AddTicks(6354) });

            migrationBuilder.UpdateData(
                table: "Rezervacija",
                keyColumn: "RezervacijaId",
                keyValue: 3,
                columns: new[] { "PocetniDatum", "ZavrsniDatum" },
                values: new object[] { new DateTime(2024, 8, 11, 11, 12, 2, 603, DateTimeKind.Local).AddTicks(1581), new DateTime(2024, 8, 12, 11, 12, 2, 603, DateTimeKind.Local).AddTicks(1625) });

            migrationBuilder.UpdateData(
                table: "Rezervacija",
                keyColumn: "RezervacijaId",
                keyValue: 4,
                columns: new[] { "PocetniDatum", "ZavrsniDatum" },
                values: new object[] { new DateTime(2024, 8, 13, 11, 12, 2, 603, DateTimeKind.Local).AddTicks(1632), new DateTime(2024, 8, 14, 11, 12, 2, 603, DateTimeKind.Local).AddTicks(1636) });

            migrationBuilder.UpdateData(
                table: "Rezervacija",
                keyColumn: "RezervacijaId",
                keyValue: 5,
                columns: new[] { "PocetniDatum", "ZavrsniDatum" },
                values: new object[] { new DateTime(2024, 7, 14, 11, 12, 0, 991, DateTimeKind.Local).AddTicks(9494), new DateTime(2024, 7, 16, 11, 12, 0, 997, DateTimeKind.Local).AddTicks(6354) });

            migrationBuilder.UpdateData(
                table: "Rezervacija",
                keyColumn: "RezervacijaId",
                keyValue: 6,
                columns: new[] { "PocetniDatum", "ZavrsniDatum" },
                values: new object[] { new DateTime(2024, 8, 11, 11, 12, 2, 603, DateTimeKind.Local).AddTicks(1643), new DateTime(2024, 8, 12, 11, 12, 2, 603, DateTimeKind.Local).AddTicks(1647) });

            migrationBuilder.UpdateData(
                table: "Rezervacija",
                keyColumn: "RezervacijaId",
                keyValue: 7,
                columns: new[] { "PocetniDatum", "ZavrsniDatum" },
                values: new object[] { new DateTime(2024, 7, 14, 11, 12, 0, 991, DateTimeKind.Local).AddTicks(9494), new DateTime(2024, 7, 16, 11, 12, 0, 997, DateTimeKind.Local).AddTicks(6354) });

            migrationBuilder.UpdateData(
                table: "Rezervacija",
                keyColumn: "RezervacijaId",
                keyValue: 8,
                columns: new[] { "PocetniDatum", "ZavrsniDatum" },
                values: new object[] { new DateTime(2024, 8, 13, 11, 12, 2, 603, DateTimeKind.Local).AddTicks(1653), new DateTime(2024, 8, 14, 11, 12, 2, 603, DateTimeKind.Local).AddTicks(1657) });

            migrationBuilder.UpdateData(
                table: "Rezervacija",
                keyColumn: "RezervacijaId",
                keyValue: 9,
                columns: new[] { "PocetniDatum", "ZavrsniDatum" },
                values: new object[] { new DateTime(2024, 7, 20, 11, 12, 2, 603, DateTimeKind.Local).AddTicks(1662), new DateTime(2024, 7, 21, 11, 12, 2, 603, DateTimeKind.Local).AddTicks(1667) });

            migrationBuilder.UpdateData(
                table: "Rezervacija",
                keyColumn: "RezervacijaId",
                keyValue: 10,
                columns: new[] { "PocetniDatum", "ZavrsniDatum" },
                values: new object[] { new DateTime(2024, 7, 20, 11, 12, 2, 603, DateTimeKind.Local).AddTicks(1671), new DateTime(2024, 7, 21, 11, 12, 2, 603, DateTimeKind.Local).AddTicks(1675) });

            migrationBuilder.UpdateData(
                table: "Rezervacija",
                keyColumn: "RezervacijaId",
                keyValue: 11,
                columns: new[] { "PocetniDatum", "ZavrsniDatum" },
                values: new object[] { new DateTime(2024, 8, 14, 11, 12, 2, 603, DateTimeKind.Local).AddTicks(1679), new DateTime(2024, 8, 15, 11, 12, 2, 603, DateTimeKind.Local).AddTicks(1683) });

            migrationBuilder.UpdateData(
                table: "Rezervacija",
                keyColumn: "RezervacijaId",
                keyValue: 12,
                columns: new[] { "PocetniDatum", "ZavrsniDatum" },
                values: new object[] { new DateTime(2024, 8, 17, 11, 12, 2, 603, DateTimeKind.Local).AddTicks(1688), new DateTime(2024, 8, 18, 11, 12, 2, 603, DateTimeKind.Local).AddTicks(1693) });

            migrationBuilder.UpdateData(
                table: "VoziloPregled",
                keyColumn: "VoziloPregledId",
                keyValue: 1,
                column: "Datum",
                value: new DateTime(2024, 7, 11, 11, 12, 2, 590, DateTimeKind.Local).AddTicks(3577));

            migrationBuilder.UpdateData(
                table: "VoziloPregled",
                keyColumn: "VoziloPregledId",
                keyValue: 2,
                column: "Datum",
                value: new DateTime(2024, 7, 12, 11, 12, 2, 590, DateTimeKind.Local).AddTicks(3584));

            migrationBuilder.UpdateData(
                table: "VoziloPregled",
                keyColumn: "VoziloPregledId",
                keyValue: 3,
                column: "Datum",
                value: new DateTime(2024, 7, 12, 11, 12, 2, 590, DateTimeKind.Local).AddTicks(3588));

            migrationBuilder.UpdateData(
                table: "VoziloPregled",
                keyColumn: "VoziloPregledId",
                keyValue: 4,
                column: "Datum",
                value: new DateTime(2024, 7, 13, 11, 12, 2, 590, DateTimeKind.Local).AddTicks(3593));

            migrationBuilder.UpdateData(
                table: "VoziloPregled",
                keyColumn: "VoziloPregledId",
                keyValue: 5,
                column: "Datum",
                value: new DateTime(2024, 7, 11, 11, 12, 2, 590, DateTimeKind.Local).AddTicks(3597));

            migrationBuilder.UpdateData(
                table: "VoziloPregled",
                keyColumn: "VoziloPregledId",
                keyValue: 6,
                column: "Datum",
                value: new DateTime(2024, 7, 12, 11, 12, 2, 590, DateTimeKind.Local).AddTicks(3601));

            migrationBuilder.UpdateData(
                table: "VoziloPregled",
                keyColumn: "VoziloPregledId",
                keyValue: 7,
                column: "Datum",
                value: new DateTime(2024, 7, 12, 11, 12, 2, 590, DateTimeKind.Local).AddTicks(3604));

            migrationBuilder.UpdateData(
                table: "VoziloPregled",
                keyColumn: "VoziloPregledId",
                keyValue: 8,
                column: "Datum",
                value: new DateTime(2024, 7, 13, 11, 12, 2, 590, DateTimeKind.Local).AddTicks(3608));

            migrationBuilder.AddForeignKey(
                name: "FK_VoziloPregled_Vozila_VoziloId",
                table: "VoziloPregled",
                column: "VoziloId",
                principalTable: "Vozila",
                principalColumn: "VoziloId",
                onDelete: ReferentialAction.Cascade);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_VoziloPregled_Vozila_VoziloId",
                table: "VoziloPregled");

            migrationBuilder.UpdateData(
                table: "KorisniciUloge",
                keyColumn: "KorisnikUlogaId",
                keyValue: 1,
                column: "DatumIzmjene",
                value: new DateTime(2024, 7, 6, 17, 0, 30, 237, DateTimeKind.Local).AddTicks(7947));

            migrationBuilder.UpdateData(
                table: "KorisniciUloge",
                keyColumn: "KorisnikUlogaId",
                keyValue: 2,
                column: "DatumIzmjene",
                value: new DateTime(2024, 7, 6, 17, 0, 30, 237, DateTimeKind.Local).AddTicks(7988));

            migrationBuilder.UpdateData(
                table: "KorisniciUloge",
                keyColumn: "KorisnikUlogaId",
                keyValue: 3,
                column: "DatumIzmjene",
                value: new DateTime(2024, 7, 6, 17, 0, 30, 237, DateTimeKind.Local).AddTicks(7990));

            migrationBuilder.UpdateData(
                table: "Rezervacija",
                keyColumn: "RezervacijaId",
                keyValue: 1,
                columns: new[] { "PocetniDatum", "ZavrsniDatum" },
                values: new object[] { new DateTime(2024, 7, 10, 17, 0, 29, 173, DateTimeKind.Local).AddTicks(6246), new DateTime(2024, 7, 12, 17, 0, 29, 175, DateTimeKind.Local).AddTicks(6881) });

            migrationBuilder.UpdateData(
                table: "Rezervacija",
                keyColumn: "RezervacijaId",
                keyValue: 2,
                columns: new[] { "PocetniDatum", "ZavrsniDatum" },
                values: new object[] { new DateTime(2024, 7, 10, 17, 0, 29, 173, DateTimeKind.Local).AddTicks(6246), new DateTime(2024, 7, 12, 17, 0, 29, 175, DateTimeKind.Local).AddTicks(6881) });

            migrationBuilder.UpdateData(
                table: "Rezervacija",
                keyColumn: "RezervacijaId",
                keyValue: 3,
                columns: new[] { "PocetniDatum", "ZavrsniDatum" },
                values: new object[] { new DateTime(2024, 8, 7, 17, 0, 30, 246, DateTimeKind.Local).AddTicks(1353), new DateTime(2024, 8, 8, 17, 0, 30, 246, DateTimeKind.Local).AddTicks(1390) });

            migrationBuilder.UpdateData(
                table: "Rezervacija",
                keyColumn: "RezervacijaId",
                keyValue: 4,
                columns: new[] { "PocetniDatum", "ZavrsniDatum" },
                values: new object[] { new DateTime(2024, 8, 9, 17, 0, 30, 246, DateTimeKind.Local).AddTicks(1393), new DateTime(2024, 8, 10, 17, 0, 30, 246, DateTimeKind.Local).AddTicks(1395) });

            migrationBuilder.UpdateData(
                table: "Rezervacija",
                keyColumn: "RezervacijaId",
                keyValue: 5,
                columns: new[] { "PocetniDatum", "ZavrsniDatum" },
                values: new object[] { new DateTime(2024, 7, 10, 17, 0, 29, 173, DateTimeKind.Local).AddTicks(6246), new DateTime(2024, 7, 12, 17, 0, 29, 175, DateTimeKind.Local).AddTicks(6881) });

            migrationBuilder.UpdateData(
                table: "Rezervacija",
                keyColumn: "RezervacijaId",
                keyValue: 6,
                columns: new[] { "PocetniDatum", "ZavrsniDatum" },
                values: new object[] { new DateTime(2024, 8, 7, 17, 0, 30, 246, DateTimeKind.Local).AddTicks(1398), new DateTime(2024, 8, 8, 17, 0, 30, 246, DateTimeKind.Local).AddTicks(1400) });

            migrationBuilder.UpdateData(
                table: "Rezervacija",
                keyColumn: "RezervacijaId",
                keyValue: 7,
                columns: new[] { "PocetniDatum", "ZavrsniDatum" },
                values: new object[] { new DateTime(2024, 7, 10, 17, 0, 29, 173, DateTimeKind.Local).AddTicks(6246), new DateTime(2024, 7, 12, 17, 0, 29, 175, DateTimeKind.Local).AddTicks(6881) });

            migrationBuilder.UpdateData(
                table: "Rezervacija",
                keyColumn: "RezervacijaId",
                keyValue: 8,
                columns: new[] { "PocetniDatum", "ZavrsniDatum" },
                values: new object[] { new DateTime(2024, 8, 9, 17, 0, 30, 246, DateTimeKind.Local).AddTicks(1403), new DateTime(2024, 8, 10, 17, 0, 30, 246, DateTimeKind.Local).AddTicks(1405) });

            migrationBuilder.UpdateData(
                table: "Rezervacija",
                keyColumn: "RezervacijaId",
                keyValue: 9,
                columns: new[] { "PocetniDatum", "ZavrsniDatum" },
                values: new object[] { new DateTime(2024, 7, 16, 17, 0, 30, 246, DateTimeKind.Local).AddTicks(1407), new DateTime(2024, 7, 17, 17, 0, 30, 246, DateTimeKind.Local).AddTicks(1409) });

            migrationBuilder.UpdateData(
                table: "Rezervacija",
                keyColumn: "RezervacijaId",
                keyValue: 10,
                columns: new[] { "PocetniDatum", "ZavrsniDatum" },
                values: new object[] { new DateTime(2024, 7, 16, 17, 0, 30, 246, DateTimeKind.Local).AddTicks(1411), new DateTime(2024, 7, 17, 17, 0, 30, 246, DateTimeKind.Local).AddTicks(1413) });

            migrationBuilder.UpdateData(
                table: "Rezervacija",
                keyColumn: "RezervacijaId",
                keyValue: 11,
                columns: new[] { "PocetniDatum", "ZavrsniDatum" },
                values: new object[] { new DateTime(2024, 8, 10, 17, 0, 30, 246, DateTimeKind.Local).AddTicks(1415), new DateTime(2024, 8, 11, 17, 0, 30, 246, DateTimeKind.Local).AddTicks(1417) });

            migrationBuilder.UpdateData(
                table: "Rezervacija",
                keyColumn: "RezervacijaId",
                keyValue: 12,
                columns: new[] { "PocetniDatum", "ZavrsniDatum" },
                values: new object[] { new DateTime(2024, 8, 13, 17, 0, 30, 246, DateTimeKind.Local).AddTicks(1420), new DateTime(2024, 8, 14, 17, 0, 30, 246, DateTimeKind.Local).AddTicks(1422) });

            migrationBuilder.UpdateData(
                table: "VoziloPregled",
                keyColumn: "VoziloPregledId",
                keyValue: 1,
                column: "Datum",
                value: new DateTime(2024, 7, 7, 17, 0, 30, 237, DateTimeKind.Local).AddTicks(8076));

            migrationBuilder.UpdateData(
                table: "VoziloPregled",
                keyColumn: "VoziloPregledId",
                keyValue: 2,
                column: "Datum",
                value: new DateTime(2024, 7, 8, 17, 0, 30, 237, DateTimeKind.Local).AddTicks(8080));

            migrationBuilder.UpdateData(
                table: "VoziloPregled",
                keyColumn: "VoziloPregledId",
                keyValue: 3,
                column: "Datum",
                value: new DateTime(2024, 7, 8, 17, 0, 30, 237, DateTimeKind.Local).AddTicks(8082));

            migrationBuilder.UpdateData(
                table: "VoziloPregled",
                keyColumn: "VoziloPregledId",
                keyValue: 4,
                column: "Datum",
                value: new DateTime(2024, 7, 9, 17, 0, 30, 237, DateTimeKind.Local).AddTicks(8084));

            migrationBuilder.UpdateData(
                table: "VoziloPregled",
                keyColumn: "VoziloPregledId",
                keyValue: 5,
                column: "Datum",
                value: new DateTime(2024, 7, 7, 17, 0, 30, 237, DateTimeKind.Local).AddTicks(8086));

            migrationBuilder.UpdateData(
                table: "VoziloPregled",
                keyColumn: "VoziloPregledId",
                keyValue: 6,
                column: "Datum",
                value: new DateTime(2024, 7, 8, 17, 0, 30, 237, DateTimeKind.Local).AddTicks(8088));

            migrationBuilder.UpdateData(
                table: "VoziloPregled",
                keyColumn: "VoziloPregledId",
                keyValue: 7,
                column: "Datum",
                value: new DateTime(2024, 7, 8, 17, 0, 30, 237, DateTimeKind.Local).AddTicks(8090));

            migrationBuilder.UpdateData(
                table: "VoziloPregled",
                keyColumn: "VoziloPregledId",
                keyValue: 8,
                column: "Datum",
                value: new DateTime(2024, 7, 9, 17, 0, 30, 237, DateTimeKind.Local).AddTicks(8092));

            migrationBuilder.AddForeignKey(
                name: "FK_VoziloPregled_Vozila_VoziloId",
                table: "VoziloPregled",
                column: "VoziloId",
                principalTable: "Vozila",
                principalColumn: "VoziloId",
                onDelete: ReferentialAction.Restrict);
        }
    }
}
