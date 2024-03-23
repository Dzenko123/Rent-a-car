using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace RentACar.Services.Migrations
{
    public partial class test2 : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "Id",
                table: "TipVozila",
                newName: "TipVozilaId");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "TipVozilaId",
                table: "TipVozila",
                newName: "Id");
        }
    }
}
