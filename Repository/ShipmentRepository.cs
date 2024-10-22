using Dapper.Contrib.Extensions;
using DapperCURD.Model;
using System.Data;

namespace DapperCURD.Repository
{
    public class ShipmentRepository
    {
        public readonly IDbConnection _db;

        public ShipmentRepository(IDbConnection db)
        {
            _db = db;
        }

        //GET ALL
        public async Task<IEnumerable<Shipment>> GetAllShipment()
        {
            return await _db.GetAllAsync<Shipment>();
        }
        //CREATE
        public async Task<int> AddShipment(Shipment shipment)
        {
            return await _db.InsertAsync(shipment);
        }

        //READ
        public async Task<Shipment> GetShipmentById(int id)
        {
            return await _db.GetAsync<Shipment>(id);
        }

        //UPDATE
        public async Task UpdateShipment(Shipment shipment)
        {
            await _db.UpdateAsync(shipment);
        }

        //DELETE
        public async Task DeleteShipment(int id)
        {
            await _db.DeleteAsync(new Shipment { Id = id });
        }
    }
}
