using Microsoft.AspNetCore.Mvc;
using RetailOpsLabMvc.Data;
using RetailOpsLabMvc.Models;

namespace RetailOpsLabMvc.Controllers;

public class CustomersController : Controller
{
    private readonly RetailRepository _repository;

    public CustomersController(RetailRepository repository)
    {
        _repository = repository;
    }

    public async Task<IActionResult> Index()
    {
        var customers = await _repository.GetCustomersAsync();
        return View(customers);
    }

    public IActionResult Create()
    {
        return View(new CustomerViewModel());
    }

    [HttpPost]
    public async Task<IActionResult> Create(CustomerViewModel model)
    {
        if (!ModelState.IsValid)
            return View(model);

        try
        {
            var newId = await _repository.CreateCustomerAsync(model);
            TempData["Success"] = $"Customer created. New ID = {newId}";
            return RedirectToAction(nameof(Index));
        }
        catch (Exception ex)
        {
            ModelState.AddModelError(string.Empty, ex.Message);
            return View(model);
        }
    }
}
