using System.Diagnostics;
using Microsoft.AspNetCore.Mvc;
using aspnet.Models;

namespace aspnet.Controllers;

public class HomeController : Controller
{
  private readonly ILogger<HomeController> _logger;

  public HomeController(ILogger<HomeController> logger)
  {
    _logger = logger;
  }

  public IActionResult Index()
  {
    var redisCache = new RedisCache("redis:6379");
    var timeKey = "timekey";


    var value = redisCache.Get(timeKey);
    Console.WriteLine($"last access time from Redis cache: {value}");

    var now = DateTime.Now;
    redisCache.Set(timeKey, now.ToString(), TimeSpan.FromMinutes(1));

    return View();
  }

  public IActionResult Privacy()
  {
    return View();
  }

  [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
  public IActionResult Error()
  {
    return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
  }
}
