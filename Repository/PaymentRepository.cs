using DapperCURD.Model;
using System.Data;
using Dapper.Contrib.Extensions;

namespace DapperCURD.Repository
{
    public class PaymentRepository
    {
        public readonly IDbConnection _db;

        public PaymentRepository(IDbConnection db) { _db = db; }

        //GET ALL
        public async Task<IEnumerable<Payment>> GetAllPayment()
        {
            return await _db.GetAllAsync<Payment>();
        }
        //CREATE
        public async Task<int> AddPayment(Payment payment)
        {
            return await _db.InsertAsync(payment);
        }

        //READ
        public async Task<Payment> GetPaymentById(int id)
        {
            return await _db.GetAsync<Payment>(id);
        }

        //UPDATE
        public async Task UpdatePayment(Payment payment)
        {
            await _db.UpdateAsync(payment);
        }

        //DELETE
        public async Task DeletePayment(int id)
        {
            await _db.DeleteAsync(new Payment { Id = id });
        }
    }
}
