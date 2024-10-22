using Dapper.Contrib.Extensions;

namespace DapperCURD.Model
{
    public class Shipper
    {
        [Key]
        public int Id { get; set; }
        public string Name { get; set; }
        public string Phone { get; set; }
        public string Email { get; set; }
    }
}
