using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ADB.SA.Reports.Entities.DTO
{
    public class SystemArchitectureContentDTO : GenericContentDTO
    {
        public List<ApplicationDataFlowDTO> AppDataFlow { get; set; }
    }
}
