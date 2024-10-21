using Microsoft.AspNetCore.Mvc;
using DapperCURD.Model;
using DapperCURD.Repository;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace DapperCURD.Controller
{
    namespace DapperCURD.Controller
    {
        [Route("api/[controller]")]
        [ApiController]
        public class CategoryController : ControllerBase
        {
            private readonly CategoryRepository _categoryRepository;

            public CategoryController(CategoryRepository categoryRepository)
            {
                _categoryRepository = categoryRepository;
            }

            // GET: api/category
            [HttpGet]
            public async Task<IEnumerable<Category>> GetAllCategories()
            {
                return await _categoryRepository.GetAllCategories();
            }

            // GET: api/category/{id}
            [HttpGet("{id}")]
            public async Task<ActionResult<Category>> GetCategoryById(int id)
            {
                var category = await _categoryRepository.GetCategoryById(id);
                if (category == null)
                {
                    return NotFound();
                }
                return category;
            }

            // POST: api/category
            [HttpPost]
            public async Task<ActionResult<int>> AddCategory(Category category)
            {
                var newCategoryId = await _categoryRepository.AddCategory(category);
                return CreatedAtAction(nameof(GetCategoryById), new { id = newCategoryId }, newCategoryId);
            }

            // PUT: api/category/{id}
            [HttpPut("{id}")]
            public async Task<IActionResult> UpdateCategory(int id, Category category)
            {
                if (id != category.Id)
                {
                    return BadRequest();
                }
                await _categoryRepository.UpdateCategory(category);
                return NoContent();
            }

            // DELETE: api/category/{id}
            [HttpDelete("{id}")]
            public async Task<IActionResult> DeleteCategory(int id)
            {
                await _categoryRepository.DeleteCategory(id);
                return NoContent();
            }
        }
    }

}
