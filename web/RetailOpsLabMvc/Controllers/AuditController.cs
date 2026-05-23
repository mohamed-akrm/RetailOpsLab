using Microsoft.AspNetCore.Mvc;
using RetailOpsLabMvc.Data;

namespace RetailOpsLabMvc.Controllers;

public class AuditController : Controller
{
    private readonly RetailRepository _repository;

    public AuditController(RetailRepository repository)
    {
        _repository = repository;
    }

    public async Task<IActionResult> Index()
    {
        var logs = await _repository.GetRecentAuditLogsAsync();
        return View(logs);
    }
}
