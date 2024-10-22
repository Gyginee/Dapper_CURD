using Dapper.Contrib.Extensions;

namespace DapperCURD.Model
{
    public class Shipment
    {
    [Key]
    public int Id { get; set; }
    public int OrderId { get; set; }
    public int ShipperId { get; set; }
    public DateTime ShipmentDate { get; set; }
    public string TrackingNumber { get; set; }
    public string Status { get; set; }
    }
}
