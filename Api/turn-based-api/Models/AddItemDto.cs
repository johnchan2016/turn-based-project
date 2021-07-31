using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace turn_based_api.Models
{
    public class AddItemDto
    {
        public string GameId { get; set; }
        public int Heap1 { get; set; }
        public int Heap2 { get; set; }
        public int Heap3 { get; set; }
        public string User1 {get;set;}
        public string User2 { get; set; }
        public string LastMoveBy { get; set; }
    }
}
