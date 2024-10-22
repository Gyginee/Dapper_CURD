using Microsoft.AspNetCore.Mvc;
using DapperCURD.Repository;
using DapperCURD.Model;

namespace DapperCURD.Controller
{
    [Route("api/[controller]")]
    [ApiController]
    public class ShipperController : ControllerBase
    {
        private readonly ShipperRepository _shipperRepository;

        public ShipperController(ShipperRepository shipperRepository)
        {
            _shipperRepository = shipperRepository;
        }

        //GET: api/shipper
        [HttpGet]
        public async Task<IEnumerable<Shipper>> GetAllShipper()
        {
            return await _shipperRepository.GetAllShipper();
        }

        //GET: api/shipper/{id}
        [HttpGet("{id}")]
        public async Task<ActionResult<Shipper>> GetShipperById(int id)
        {
            var shipper = await _shipperRepository.GetShipperById(id);
            if (shipper == null) {
                return NotFound();
            }
            return shipper;
        }

        //POST: api/shipper
        [HttpPost]
        public async Task<ActionResult<int>> AddShipper(Shipper shipper)
        {
            var newShipperId = await _shipperRepository.AddShipper(shipper);
            return CreatedAtAction(nameof(GetShipperById), new { id = newShipperId }, newShipperId);
        }

        //PUT: api/shipper/{id}
        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateShipper(int id, Shipper shipper)
        {
            if (id != shipper.Id)
            {
                return BadRequest();
            }
            await _shipperRepository.UpdateShipper(shipper);
            return NoContent();
        }

        //DELETE: api/shipper/{id}
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteShipper(int id)
        {
            await _shipperRepository.DeleteShipper(id);
            return NoContent();
        }


    }
}
