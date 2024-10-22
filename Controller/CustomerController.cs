using DapperCURD.Model;
using DapperCURD.Repository;
using Microsoft.AspNetCore.Mvc;

namespace DapperCURD.Controller
{
    [Route("api/[controller]")]
    [ApiController]
    public class CustomerController : ControllerBase
    {
        private readonly CustomerRepository _customerRepository;

        public CustomerController(CustomerRepository customerRepository)
        {
            _customerRepository = customerRepository;
        }

        //GET: api/customer
        [HttpGet]
        public async Task<IEnumerable<Customer>> GetAllCustomer()
        {
            return await _customerRepository.GetAllCustomer();
        }

        //GET: api/customer/{id}
        [HttpGet("{id}")]
        public async Task<ActionResult<Customer>> GetCustomerById(int id)
        {
            var customer = await _customerRepository.GetCustomerById(id);
            if (customer == null)
            {
                return NotFound();
            }
            return customer;
        }

        //POST: api/customer
        [HttpPost]
        public async Task<ActionResult<int>> AddCustomer(Customer customer)
        {
            var newCustomerId = await _customerRepository.AddCustomer(customer);
            return CreatedAtAction(nameof(GetCustomerById), new { id = newCustomerId }, newCustomerId);
        }

        //PUT: api/customer/{id}
        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateCustomer(int id, Customer customer)
        {
            if (id != customer.Id)
            {
                return BadRequest();
            }
            await _customerRepository.UpdateCustomer(customer);
            return NoContent();
        }

        //DELETE: api/customer/{id}
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteCustomer(int id)
        {
            await _customerRepository.DeleteCustomer(id);
            return NoContent();
        }
    }
}
