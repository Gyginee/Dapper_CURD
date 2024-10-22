using DapperCURD.Model;
using DapperCURD.Repository;
using Microsoft.AspNetCore.Mvc;

namespace DapperCURD.Controller
{
    [Route("api/[controller]")]
    [ApiController]
    public class ShipmentController : ControllerBase
    {

        private readonly ShipmentRepository _shipmentRepository;

        public ShipmentController(ShipmentRepository shipmentRepository)
        {
            _shipmentRepository = shipmentRepository;
        }

        //GET: api/shipment
        [HttpGet]
        public async Task<IEnumerable<Shipment>> GetAllShipment()
        {
            return await _shipmentRepository.GetAllShipment();
        }

        //GET: api/shipment/{id}
        [HttpGet("{id}")]
        public async Task<ActionResult<Shipment>> GetShipmentById(int id)
        {
            var shipment = await _shipmentRepository.GetShipmentById(id);
            if (shipment == null)
            {
                return NotFound();
            }
            return shipment;
        }

        //POST: api/shipment
        [HttpPost]
        public async Task<ActionResult<int>> AddShipment(Shipment shipment)
        {
            var newShipmentId = await _shipmentRepository.AddShipment(shipment);
            return CreatedAtAction(nameof(GetShipmentById), new { id = newShipmentId }, newShipmentId);
        }

        //PUT: api/shipment/{id}
        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateShipment(int id, Shipment shipment)
        {
            if (id != shipment.Id)
            {
                return BadRequest();
            }
            await _shipmentRepository.UpdateShipment(shipment);
            return NoContent();
        }

        //DELETE: api/shipment/{id}
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteShipment(int id)
        {
            await _shipmentRepository.DeleteShipment(id);
            return NoContent();
        }


    }
}
