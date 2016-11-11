using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ADB.SA.Reports.Entities.DTO;
using ADB.SA.Reports.Data;
using ADB.SA.Reports.Utilities.WMF;
using ADB.SA.Reports.Utilities;
using ADB.SA.Reports.Global;
using System.IO;
using Microsoft.Practices.EnterpriseLibrary.Logging;

namespace ADB.SA.Reports.Presenter.Content
{
    public abstract class MainContentStrategyBase
    {
        public abstract object BuildContent(EntityDTO dto);
        public DiagramContent BuildDiagramContent(EntityDTO dto)
        {
            EntityData data = new EntityData();
            FileData files = new FileData();
            DiagramSizeData size = new DiagramSizeData();
            FileDTO file = files.GetFile(dto.DGXFileName);
            byte[] imageBytes = file.Data;
            string path = string.Format("{0}_{1}", file.Date.ToFileTime().ToString(), dto.DGXFileName);
            int poolCount = data.GetPoolCount(dto.ID);
            double percentage = size.GetPercentage(dto.ID);
            WmfImageManager imageManager = new WmfImageManager(dto, imageBytes,
                path, dto.Type, poolCount, false, percentage);
            path = imageManager.ProcessImage();

            DiagramContent dc = new DiagramContent();
            dc.DiagramPath = path.Replace(@"\", @"/")+"?time="+DateTime.Now.Ticks.ToString();
            dc.Percentage = percentage;
            return dc;
        }

        public bool ShowResize()
        {
            List<string> list = File.ReadAllLines(AppDomain.CurrentDomain.BaseDirectory + "resize_admin.txt").ToList();
            string currentUser = SAWebContext.User.Identity.Name;
            Logger.Write("current user" + currentUser);
            if (list.Contains(currentUser, new CurrentUserComparer()))
            {
                return true;
            }
            
            return false;
        }
    }

    public class CurrentUserComparer : IEqualityComparer<string>
    {
        public CurrentUserComparer()
        {
        }

        public bool Equals(string x, string y)
        {
            return x.Equals(y, StringComparison.CurrentCultureIgnoreCase);
        }

        #region IEqualityComparer<string> Members


        public int GetHashCode(string obj)
        {
            return obj.GetHashCode();
        }

        #endregion
    }

}
