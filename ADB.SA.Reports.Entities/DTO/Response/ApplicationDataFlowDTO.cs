using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ADB.SA.Reports.Entities.DTO
{
    public class ApplicationDataFlowDTO
    {
        public string Source { get; set; }
        public string Destination { get; set; }
        public string Description { get; set; }
        public string DataEntities { get; set; }
    }
}
