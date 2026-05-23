using Microsoft.AspNetCore.Mvc;
using RetailOpsLabMvc.Data;

namespace RetailOpsLabMvc.Controllers;

public class ReportsController : Controller
{
    private readonly RetailRepository _repository;

    public ReportsController(RetailRepository repository)
    {
        _repository = repository;
    }

    public async Task<IActionResult> Sales(DateTime? fromDate, DateTime? toDate)
    {
        var from = fromDate ?? DateTime.Today.AddYears(-2);
        var to = toDate ?? DateTime.Today.AddDays(1);

        ViewBag.FromDate = from.ToString("yyyy-MM-dd");
        ViewBag.ToDate = to.ToString("yyyy-MM-dd");

        var rows = await _repository.GetSalesReportAsync(from, to);
        return View(rows);
    }
}
