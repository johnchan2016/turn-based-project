using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Amazon.DynamoDBv2;
using Amazon.DynamoDBv2.DataModel;
using Amazon.DynamoDBv2.DocumentModel;
using Amazon.DynamoDBv2.Model;
using turn_based_api.Entities;
using turn_based_api.Models;
using turn_based_api.Services.Interface;

namespace turn_based_api.Services
{

    public class TurnbasedService: ITurnbasedService
    {
        AmazonDynamoDBClient client = null;
        DynamoDBContext context = null;

        public TurnbasedService()
        {
            client = new AmazonDynamoDBClient();
            context = new DynamoDBContext(client);
        }

        public async Task<TurnbasedGame> GetItem(string gameId)
        {
            var game = await context.LoadAsync<TurnbasedGame>(gameId).ConfigureAwait(false);

            return game;
        }

        public async Task AddItem(AddItemDto dto)
        {
            var game = new TurnbasedGame();
            var guid = new Guid().ToString();

            game.GameId = guid.Split('-')[0];
            game.Heap1 = dto.Heap1;
            game.Heap2 = dto.Heap2;
            game.Heap3 = dto.Heap3;
            game.User1 = dto.User1;
            game.User2 = dto.User2;
            game.LastMoveBy = dto.LastMoveBy;

            await context.SaveAsync(game);
        }

        public async Task UpdateItem(AddItemDto dto)
        {
            var game = await context.LoadAsync<TurnbasedGame>(dto.GameId).ConfigureAwait(false);

            game.Heap1 = dto.Heap1;
            game.Heap2 = dto.Heap2;
            game.Heap3 = dto.Heap3;
            game.User1 = dto.User1;
            game.User2 = dto.User2;
            game.LastMoveBy = dto.LastMoveBy;

            await context.SaveAsync(game);
        }
    }
}
