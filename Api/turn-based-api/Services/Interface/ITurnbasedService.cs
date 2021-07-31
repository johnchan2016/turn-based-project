using Amazon.DynamoDBv2.DocumentModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using turn_based_api.Entities;
using turn_based_api.Models;

namespace turn_based_api.Services.Interface
{
    public interface ITurnbasedService
    {
        Task<TurnbasedGame> GetItem(string gameId);
        Task AddItem(AddItemDto dto);
    }
}
