using Microsoft.AspNetCore.Mvc;
using RetailOpsLab.Data;

namespace RetailOpsLab.Controllers;

public class HomeController : Controller
{
    private readonly RetailRepository _repository;

    public HomeController(RetailRepository repository)
    {
        _repository = repository;
    }

    public async Task<IActionResult> Index()
    {
        try
        {
            var model = await _repository.GetDashboardNumbersAsync();
            return View(model);
        }
        catch (Exception ex)
        {
            ViewBag.ErrorMessage = ex.Message;
            return View();
        }
    }
}
