using Dapper;
using System.Data;
using System.Collections.Generic;
using System.Threading.Tasks;
using DapperCURD.Model;

namespace DapperCURD.Repository
{

    public class ProductRepository
    {
        private readonly IDbConnection _db;

        public ProductRepository(IDbConnection db)
        {
            _db = db;
        }

        // Create
        public async Task<int> AddProduct(Product product)
        {
            var query = "INSERT INTO Products (Name, Price, CategoryId) VALUES (@Name, @Price, @CategoryId); SELECT CAST(SCOPE_IDENTITY() AS int);";
            return await _db.ExecuteScalarAsync<int>(query, product);
        }

        // Read
        public async Task<Product> GetProductById(int id)
        {
            var query = "SELECT * FROM Products WHERE Id = @Id;";
            return await _db.QuerySingleOrDefaultAsync<Product>(query, new { Id = id });
        }

        // Update
        public async Task UpdateProduct(Product product)
        {
            var query = "UPDATE Products SET Name = @Name, Price = @Price, CategoryId = @CategoryId WHERE Id = @Id;";
            await _db.ExecuteAsync(query, product);
        }

        // Delete
        public async Task DeleteProduct(int id)
        {
            var query = "DELETE FROM Products WHERE Id = @Id;";
            await _db.ExecuteAsync(query, new { Id = id });
        }

        // Get All Products
        public async Task<IEnumerable<Product>> GetAllProducts()
        {
            var query = "SELECT * FROM Products;";
            return await _db.QueryAsync<Product>(query);
        }
    }
}