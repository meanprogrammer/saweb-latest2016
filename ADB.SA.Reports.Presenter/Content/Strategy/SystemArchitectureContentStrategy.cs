using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ADB.SA.Reports.Global;
using ADB.SA.Reports.Entities.DTO;
using ADB.SA.Reports.Data;

namespace ADB.SA.Reports.Presenter.Content
{
    public class SystemArchitectureContentStrategy : MainContentStrategyBase
    {
        SystemArchData sysData;
        public SystemArchitectureContentStrategy()
        {
            sysData = new SystemArchData();
        }

        public override object BuildContent(EntityDTO dto)
        {
            SystemArchitectureContentDTO content = new SystemArchitectureContentDTO();
            content.Diagram = BuildDiagramContent(dto);
            content.DiagramDescription = DiagramDescription(dto);
            content.CurrentID = dto.ID;
            content.ShowResize = ShowResize();
            content.AppDataFlow = BuildApplicationDataFlow(dto);
            return content;
        }

        private List<ApplicationDataFlowDTO> BuildApplicationDataFlow(EntityDTO dto)
        {
            return sysData.GetSourceAndDestination(dto.ID);
        }

        private string BuildCommentsSection(EntityDTO dto)
        {
            return string.Format(GlobalStringResource.CommentFormHtml, dto.Name, dto.ID);
        }

        protected string DiagramDescription(EntityDTO dto)
        {
            dto.ExtractProperties();
            string description = dto.RenderHTML("Description", ADB.SA.Reports.Entities.Enums.RenderOption.Break);
            if (string.IsNullOrEmpty(description))
            {
                description = "There is no description for this diagram.";
            }

            return description;
        }
    }
}
