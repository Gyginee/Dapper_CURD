using Dapper.Contrib.Extensions;

namespace DapperCURD.Model
{
    public class Payment
    {
        [Key]
        public int Id { get; set; }
        public int OrderId { get; set; }
        public string Method { get; set; }
        public DateTime Date { get; set; }
        public float Amount { get; set; }
    }
}
