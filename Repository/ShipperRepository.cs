using Dapper;
using System.Data;
using DapperCURD.Model;
using Dapper.Contrib.Extensions;

namespace DapperCURD.Repository
{
    public class ShipperRepository
    {
        public readonly IDbConnection _db;

        public ShipperRepository(IDbConnection db) { _db = db; }

        //GET ALL
        public async Task<IEnumerable<Shipper>> GetAllShipper()
        {
            return await _db.GetAllAsync<Shipper>();
        }
        //CREATE
        public async Task<int> AddShipper(Shipper shipper)
        {
            return await _db.InsertAsync(shipper);
        }

        //READ
        public async Task<Shipper> GetShipperById(int id)
        {
            return await _db.GetAsync<Shipper>(id);
        }

        //UPDATE
        public async Task UpdateShipper(Shipper shipper)
        {
            await _db.UpdateAsync(shipper);
        }

        //DELETE
        public async Task DeleteShipper(int id)
        {   
            await _db.DeleteAsync(new Shipper { Id = id });
        }
    }

}
