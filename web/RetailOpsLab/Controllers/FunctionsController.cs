using Microsoft.AspNetCore.Mvc;
using RetailOpsLab.Data;
using RetailOpsLab.Models;

namespace RetailOpsLab.Controllers;

public class FunctionsController : Controller
{
    private readonly RetailRepository _repository;

    public FunctionsController(RetailRepository repository)
    {
        _repository = repository;
    }

    public async Task<IActionResult> Index()
    {
        var model = await _repository.RunFunctionLabAsync(new FunctionLabViewModel());
        return View(model);
    }

    [HttpPost]
    public async Task<IActionResult> Index(FunctionLabViewModel model)
    {
        var result = await _repository.RunFunctionLabAsync(model);
        return View(result);
    }
}
