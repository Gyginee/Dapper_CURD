using System.Data;
using Dapper;
using Dapper.Contrib.Extensions;
using DapperCURD.Model;

namespace DapperCURD.Repository
{
    public class CustomerRepository
    {
        public readonly IDbConnection _db;

        public CustomerRepository(IDbConnection db) 
        { 
            _db = db;
        }

        //GET ALL
        public async Task<IEnumerable<Customer>> GetAllCustomer()
        {
            return await _db.GetAllAsync<Customer>();
        }
        //CREATE
        public async Task<int> AddCustomer(Customer customer)
        {
            return await _db.InsertAsync(customer);
        }

        //READ
        public async Task<Customer> GetCustomerById(int id)
        {
            return await _db.GetAsync<Customer>(id);
        }

        //UPDATE
        public async Task UpdateCustomer(Customer customer)
        {
            await _db.UpdateAsync(customer);
        }

        //DELETE
        public async Task DeleteCustomer(int id)
        {
            await _db.DeleteAsync(new Customer { Id = id });
        }

    }
}
