using Dapper;
using System.Data;
using System.Threading.Tasks;
using DapperCURD.Model;
using System.Collections.Generic;


namespace DapperCURD.Repository
{
    public class CategoryRepository
    {
        private readonly IDbConnection _db;

        public CategoryRepository(IDbConnection db)
        {
            _db = db;
        }

        // Get all categories
        public async Task<IEnumerable<Category>> GetAllCategories()
        {
            var query = "SELECT * FROM Categories;";
            return await _db.QueryAsync<Category>(query);
        }

        // Get category by Id
        public async Task<Category> GetCategoryById(int id)
        {
            var query = "SELECT * FROM Categories WHERE Id = @Id;";
            return await _db.QuerySingleOrDefaultAsync<Category>(query, new { Id = id });
        }

        // Add a new category
        public async Task<int> AddCategory(Category category)
        {
            var query = "INSERT INTO Categories (Name) VALUES (@Name); SELECT CAST(SCOPE_IDENTITY() AS int);";
            return await _db.ExecuteScalarAsync<int>(query, category);
        }

        // Update a category
        public async Task UpdateCategory(Category category)
        {
            var query = "UPDATE Categories SET Name = @Name WHERE Id = @Id;";
            await _db.ExecuteAsync(query, category);
        }

        // Delete a category
        public async Task DeleteCategory(int id)
        {
            var query = "DELETE FROM Categories WHERE Id = @Id;";
            await _db.ExecuteAsync(query, new { Id = id });
        }
    }

}
