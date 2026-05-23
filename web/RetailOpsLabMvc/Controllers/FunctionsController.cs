using Microsoft.AspNetCore.Mvc;
using RetailOpsLabMvc.Data;
using RetailOpsLabMvc.Models;

namespace RetailOpsLabMvc.Controllers;

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
        model.RelatedProducts = new();
        var result = await _repository.RunFunctionLabAsync(model);
        return View(result);
    }
}
