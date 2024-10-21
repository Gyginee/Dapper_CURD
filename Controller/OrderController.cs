using Microsoft.AspNetCore.Mvc;
using DapperCURD.Model;
using DapperCURD.Repository;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace DapperCURD.Controller
{
    [Route("api/[controller]")]
    [ApiController]
    public class OrderController : ControllerBase
    {
        private readonly OrderRepository _orderRepository;
        public OrderController(OrderRepository orderRepository)
        {
            _orderRepository = orderRepository;
        }

        // GET: api/order
        [HttpGet]
        public async Task<IEnumerable<Order>> GetAllOrder()
        {
            return await _orderRepository.GetAllOrder();
        }

        // GET: api/order/{id}
        [HttpGet("{id}")]
        public async Task<ActionResult<OrderDetail>> GetOrderDetailById(int id)
        {
            var orderDetail = await _orderRepository.GetOrderDetailById(id);
            if (orderDetail == null)
            {
                return NotFound();
            }
            return orderDetail;
        }

        // POST: api/order
        [HttpPost]
        public async Task<ActionResult<int>> AddOrder(Order order)
        {
            var newOrderId = await _orderRepository.AddOrder(order);
            return CreatedAtAction(nameof(GetOrderDetailById), new { id = newOrderId }, newOrderId);
        }

        // PUT: api/order/{id}
        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateOrder(int id, Order order)
        {
            if (id != order.Id)
            {
                return BadRequest();
            }
            await _orderRepository.UpdateOrder(order);
            return NoContent();
        }

        // DELETE: api/order/{id}
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteOrder(int id)
        {
            await _orderRepository.DeleteOrder(id);
            return NoContent();
        }
    }
}
