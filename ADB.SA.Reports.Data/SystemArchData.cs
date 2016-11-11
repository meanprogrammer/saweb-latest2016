using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.Practices.EnterpriseLibrary.Data;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using ADB.SA.Reports.Global;
using ADB.SA.Reports.Entities.DTO;
using System.Data;

namespace ADB.SA.Reports.Data
{
    public class SystemArchData
    {
        Database db;
        ICacheManager cache;

        public SystemArchData()
        {
            db = DatabaseFactory.CreateDatabase(GlobalStringResource.Data_DefaultConnection);
            cache = CacheFactory.GetCacheManager();
        }

        public List<ApplicationDataFlowDTO> GetSourceAndDestination(int id)
        {
            List<ApplicationDataFlowDTO> list = new List<ApplicationDataFlowDTO>();
            string sql = "select e.* from relationship r inner join entity e on r.id2 = e.id where r.id1 = {0} and e.type = 592";
            List<EntityDTO> flows = DataHelper.ExecuteReaderReturnDTO(db, id,
                                sql);
            foreach (EntityDTO app in flows)
            {
                app.ExtractProperties();
                ApplicationDataFlowDTO adf = new ApplicationDataFlowDTO();
                adf.Source = app.RenderHTML("From Application", ADB.SA.Reports.Entities.Enums.RenderOption.None);
                adf.Destination = app.RenderHTML("To Application", ADB.SA.Reports.Entities.Enums.RenderOption.None);
                EntityDTO descDto = GetDescriptionAndDataEntities(app.ID);
                if (descDto != null)
                {
                    descDto.ExtractProperties();
                    adf.Description = descDto.RenderHTML("Description", ADB.SA.Reports.Entities.Enums.RenderOption.None);
                    adf.DataEntities = descDto.RenderHTML("Data Entities", ADB.SA.Reports.Entities.Enums.RenderOption.Break);
                }
                list.Add(adf);

            }
            return list;
        }

        private EntityDTO GetDescriptionAndDataEntities(int id)
        {
            string sql = "select e.* from relationship r inner join entity e on r.id2 = e.id where r.id1 = {0} and e.type = 154";
            List<EntityDTO> flows = DataHelper.ExecuteReaderReturnDTO(db, id,
                                sql);

            return flows.FirstOrDefault();
            
        }
    }
}
