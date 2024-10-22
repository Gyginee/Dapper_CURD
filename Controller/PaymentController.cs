using DapperCURD.Model;
using DapperCURD.Repository;
using Microsoft.AspNetCore.Mvc;

namespace DapperCURD.Controller
{
    [Route("api/[controller]")]
    [ApiController]
    public class PaymentController : ControllerBase
    {
        private readonly PaymentRepository _paymentRepository;

        public PaymentController(PaymentRepository paymentRepository)
        {
            _paymentRepository = paymentRepository;
        }

        //GET: api/payment
        [HttpGet]
        public async Task<IEnumerable<Payment>> GetAllPayment()
        {
            return await _paymentRepository.GetAllPayment();
        }

        //GET: api/payment/{id}
        [HttpGet("{id}")]
        public async Task<ActionResult<Payment>> GetPaymentById(int id)
        {
            var payment = await _paymentRepository.GetPaymentById(id);
            if (payment == null)
            {
                return NotFound();
            }
            return payment;
        }

        //POST: api/payment
        [HttpPost]
        public async Task<ActionResult<int>> AddPayment(Payment payment)
        {
            var newPaymentId = await _paymentRepository.AddPayment(payment);
            return CreatedAtAction(nameof(GetPaymentById), new { id = newPaymentId }, newPaymentId);
        }

        //PUT: api/payment/{id}
        [HttpPut("{id}")]
        public async Task<IActionResult> UpdatePayment(int id, Payment payment)
        {
            if (id != payment.Id)
            {
                return BadRequest();
            }
            await _paymentRepository.UpdatePayment(payment);
            return NoContent();
        }

        //DELETE: api/payment/{id}
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeletePayment(int id)
        {
            await _paymentRepository.DeletePayment(id);
            return NoContent();
        }
    }
}
