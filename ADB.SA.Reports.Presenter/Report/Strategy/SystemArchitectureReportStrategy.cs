using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ADB.SA.Reports.Utilities;
using ADB.SA.Reports.Entities.DTO;
using iTextSharp.text.pdf;
using ADB.SA.Reports.Data;

namespace ADB.SA.Reports.Presenter.Report
{
    public class SystemArchitectureReportStrategy : ReportStrategyBase
    {
        EntityDTO dto;
        SystemArchData data;

        public SystemArchitectureReportStrategy()
        {
            data = new SystemArchData();
        }

        public override List<PdfContentParameter> BuildContent(ADB.SA.Reports.Entities.DTO.EntityDTO dto)
        {
            this.dto = dto;
            List<PdfContentParameter> contents = new List<PdfContentParameter>();
            contents.Add(CreateTitlePage(this.dto));
            contents.Add(CreateApplicationDataFlow(this.dto));
            return contents;
        }

        public PdfContentParameter CreateApplicationDataFlow(EntityDTO dto)
        {
            PdfPTable table = CreateTable(4, true);
            table.AddCell(CreateHeaderCell("Source Application"));
            table.AddCell(CreateHeaderCell("Target Application"));
            table.AddCell(CreateHeaderCell("Description"));
            table.AddCell(CreateHeaderCell("Data Entities"));

            List<ApplicationDataFlowDTO> list = data.GetSourceAndDestination(this.dto.ID);
            if (list != null)
            {
                foreach (ApplicationDataFlowDTO i in list)
                {
                    table.AddCell(CreatePlainContentCell(i.Source));
                    table.AddCell(CreatePlainContentCell(i.Destination));
                    table.AddCell(CreatePlainContentCell(i.Description));
                    table.AddCell(CreatePlainContentCell(ReplaceWithNewLine(i.DataEntities)));
                }
            }
            //table.KeepTogether = false;
            table.SplitLate = false;
            return new PdfContentParameter() { Table = table, Header = string.Empty, };
        }

        private string ReplaceWithNewLine(string sourceText)
        {
            if (string.IsNullOrEmpty(sourceText)) return string.Empty;

            string[] items = sourceText.Split(new string[] { "<br>" }, StringSplitOptions.RemoveEmptyEntries);
            if (items.Count() == 1)
            {
                return items.FirstOrDefault();
            }

            return sourceText.Replace("<br>", Environment.NewLine);
        }
    }
}
