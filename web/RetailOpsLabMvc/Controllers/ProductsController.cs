using Microsoft.AspNetCore.Mvc;
using RetailOpsLabMvc.Data;
using RetailOpsLabMvc.Models;

namespace RetailOpsLabMvc.Controllers;

public class ProductsController : Controller
{
    private readonly RetailRepository _repository;

    public ProductsController(RetailRepository repository)
    {
        _repository = repository;
    }

    public async Task<IActionResult> Index()
    {
        var products = await _repository.GetProductsAsync();
        return View(products);
    }

    public async Task<IActionResult> Create()
    {
        await FillProductLookups();
        return View(new ProductViewModel());
    }

    [HttpPost]
    public async Task<IActionResult> Create(ProductViewModel model)
    {
        if (!ModelState.IsValid)
        {
            await FillProductLookups();
            return View(model);
        }

        try
        {
            var newId = await _repository.CreateProductAsync(model);
            TempData["Success"] = $"Product created. New ID = {newId}";
            return RedirectToAction(nameof(Index));
        }
        catch (Exception ex)
        {
            ModelState.AddModelError(string.Empty, ex.Message);
            await FillProductLookups();
            return View(model);
        }
    }

    public async Task<IActionResult> AddStock()
    {
        var model = new AddStockViewModel
        {
            Products = await _repository.GetProductOptionsAsync(),
            Warehouses = await _repository.GetWarehousesAsync()
        };
        return View(model);
    }

    [HttpPost]
    public async Task<IActionResult> AddStock(AddStockViewModel model)
    {
        model.Products = await _repository.GetProductOptionsAsync();
        model.Warehouses = await _repository.GetWarehousesAsync();

        if (!ModelState.IsValid)
            return View(model);

        try
        {
            await _repository.AddStockAsync(model);
            TempData["Success"] = "Stock added successfully.";
            return RedirectToAction(nameof(Index));
        }
        catch (Exception ex)
        {
            ModelState.AddModelError(string.Empty, ex.Message);
            return View(model);
        }
    }

    public async Task<IActionResult> LowStock()
    {
        var rows = await _repository.GetLowStockProductsAsync();
        return View(rows);
    }

    private async Task FillProductLookups()
    {
        ViewBag.Categories = await _repository.GetCategoriesAsync();
        ViewBag.Suppliers = await _repository.GetSuppliersAsync();
    }
}
