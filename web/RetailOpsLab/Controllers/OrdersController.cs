using Microsoft.AspNetCore.Mvc;
using RetailOpsLab.Data;
using RetailOpsLab.Models;

namespace RetailOpsLab.Controllers;

public class OrdersController : Controller
{
    private readonly RetailRepository _repository;

    public OrdersController(RetailRepository repository)
    {
        _repository = repository;
    }

    public async Task<IActionResult> Index()
    {
        var orders = await _repository.GetRecentOrdersAsync();
        return View(orders);
    }

    public async Task<IActionResult> Create()
    {
        var model = await BuildCreateModel(new OrderCreateViewModel());
        return View(model);
    }

    [HttpPost]
    public async Task<IActionResult> Create(OrderCreateViewModel model)
    {
        if (!ModelState.IsValid)
        {
            model = await BuildCreateModel(model);
            return View(model);
        }

        try
        {
            var orderId = await _repository.CreateOrderAsync(model);
            TempData["Success"] = $"Order created successfully. Order ID = {orderId}";
            return RedirectToAction(nameof(Details), new { id = orderId });
        }
        catch (Exception ex)
        {
            ModelState.AddModelError(string.Empty, ex.Message);
            model = await BuildCreateModel(model);
            return View(model);
        }
    }

    public async Task<IActionResult> Details(long id)
    {
        var model = await _repository.GetOrderDetailsAsync(id);
        if (model.Order == null)
            return NotFound();

        return View(model);
    }

    private async Task<OrderCreateViewModel> BuildCreateModel(OrderCreateViewModel model)
    {
        model.Customers = await _repository.GetCustomerOptionsAsync();
        model.Products = await _repository.GetProductOptionsAsync();
        model.Warehouses = await _repository.GetWarehousesAsync();
        return model;
    }
}
