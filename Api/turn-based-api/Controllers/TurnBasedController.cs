using Amazon.DynamoDBv2.DocumentModel;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.Json;
using System.Threading.Tasks;
using turn_based_api.Entities;
using turn_based_api.Models;
using turn_based_api.Services.Interface;

namespace turn_based_api.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    //[Authorize]
    public class TurnBasedController : ControllerBase
    {
        private readonly ITurnbasedService _turnbasedService;
        public TurnBasedController(
            ITurnbasedService turnbasedService
            )
        {
            _turnbasedService = turnbasedService;
        }

        // GET api/turnbased
        [HttpGet]
        public ActionResult<IEnumerable<string>> Get()
        {
            return new string[] { "value1", "value2" };
        }

        // GET api/turnbased/5
        [HttpGet("{gameId}")]
        public async Task<TurnbasedGame> GetItems(string gameId)
        {
            try
            {
                var game = await _turnbasedService.GetItem(gameId).ConfigureAwait(false);
                return game;
            }
            catch(Exception ex)
            {
                return null;
            }
        }

        // POST api/turnbased
        [HttpPost]
        public void AddItem(AddItemDto dto)
        {
            _turnbasedService.AddItem(dto);
        }
    }
}
