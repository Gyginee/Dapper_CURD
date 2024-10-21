using Dapper;
using System.Data;
using System.Threading.Tasks;
using DapperCURD.Model;
using System.Collections.Generic;

namespace DapperCURD.Repository
{
    public class OrderRepository
    {
        private readonly IDbConnection _db;

        public OrderRepository(IDbConnection db)
        {
            _db = db;
        }

        // Method to get all orders
        public async Task<IEnumerable<Order>> GetAllOrder()
        {
            var query = "SELECT * FROM Orders";
            return await _db.QueryAsync<Order>(query);
        }

        // Method to get order detail by Id (including Product and Category)
        public async Task<OrderDetail> GetOrderDetailById(int id)
        {
            var detail = await _db.QuerySingleOrDefaultAsync<OrderDetail>("GetOrderDetailById", new { Id = id }, commandType: CommandType.StoredProcedure);
            return detail;
        }

        // Method to add a new order
        public async Task<int> AddOrder(Order order)
        {
            var query = "INSERT INTO Orders (ProductId, Quantity) VALUES (@ProductId, @Quantity); SELECT CAST(SCOPE_IDENTITY() AS int);";
            return await _db.ExecuteScalarAsync<int>(query, order);
        }

        // Method to update an order
        public async Task UpdateOrder(Order order)
        {
            var query = "UPDATE Orders SET ProductId = @ProductId, Quantity = @Quantity WHERE Id = @Id;";
            await _db.ExecuteAsync(query, order);
        }

        // Method to delete an order
        public async Task DeleteOrder(int id)
        {
            var query = "DELETE FROM Orders WHERE Id = @Id;";
            await _db.ExecuteAsync(query, new { Id = id });
        }
    }

}
