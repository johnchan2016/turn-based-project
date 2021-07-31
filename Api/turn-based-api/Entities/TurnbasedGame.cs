using Amazon.DynamoDBv2.DataModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace turn_based_api.Entities
{
    [DynamoDBTable("turn-based-game")]
    public class TurnbasedGame
    {
        [DynamoDBHashKey("gameId")]
        public string GameId { get; set; }
        [DynamoDBProperty("heap1")]
        public int Heap1 { get; set; }
        [DynamoDBProperty("heap2")]
        public int Heap2 { get; set; }
        [DynamoDBProperty("heap3")]
        public int Heap3 { get; set; }
        [DynamoDBProperty("user1")]
        public string User1 { get; set; }
        [DynamoDBProperty("user2")]
        public string User2 { get; set; }
        [DynamoDBProperty("lastMoveBy")]
        public string LastMoveBy { get; set; }
    }
}
