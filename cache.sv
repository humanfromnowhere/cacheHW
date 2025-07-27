module cache (
  input logic [31:0] addr,
  input logic clk,
  input logic rst,
  output logic [31:0] out,
  output logic hit
);

  // Define necessary logics here
  // cache_block is a structure that defines a single block in the cache
  typedef struct {
    logic valid;  //indicates if the cache block contains valid data
    logic [25:0] tag; //tag bits of the address
    logic [31:0] data; //data stored in the cache block
  } cache_block;

  //cache_mem is the 2-way set associative cache memory array
  cache_block cache_mem[1:0][3:0]; // 2-way associative, 4 sets
  //lru is the Least recently used array to keep track of LRU for each set
  logic [1:0] lru[3:0];           // LRU tracker for each set
  //index is the index bits from the address that is used to find the set in the cache memory
  logic [1:0] index;
  //addr_tag is the tag bits of the address to compare with the tag from cache
  logic [25:0] addr_tag;

  assign index = addr[3:2];
  assign addr_tag = addr[31:4];


  //initailizing all fields of the cache with 0’s when the system starts
  initial
  begin
    //Initialize cache memory and LRU bits to 0
    for (int i = 0; i < 4; i++) begin
      for (int j = 0; j < 2; j++) begin
        cache_mem[j][i].valid = 0;
        cache_mem[j][i].tag = 0;
        cache_mem[j][i].data = 0;
      end
      lru[i] = 0;
    end
  end

  //Initializing all fields of the cache with 0’s in case of a low reset signal
  always @(*)
  begin
    if (rst == 1'b0)
    begin
        //Reset cache memory and LRU bits to 0
      for (int i = 0; i < 4; i++) begin
            for (int j = 0; j < 2; j++) begin
                cache_mem[j][i].valid = 0;
                cache_mem[j][i].tag = 0;
                cache_mem[j][i].data = 0;
            end
            lru[i] = 0;
        end
    end
  end

  //the cache should be accessed and updated at each of the negative edge of the clk
  always @(negedge clk)
  begin
    if(rst == 1'b1)
    begin
      hit = 0;
      out = 0;

      //Chekc both ways for a hit
      for (int way = 0; way < 2; way++) begin
        if (cache_mem[way][index].valid && cache_mem[way][index].tag === addr_tag) begin
          hit = 1;
          out = cache_mem[way][index].data;
          lru[index] = way ^ 1;
          $display("Cache Hit: Way=%d, Index=%d, Data=0x%x", way, index, out);
        end
      end

      //Handlea cache miss
      if (!hit) begin
        automatic int replace_way = lru[index];
        cache_mem[replace_way][index].valid = 1;
        cache_mem[replace_way][index].tag = addr_tag;
        cache_mem[replace_way][index].data = addr >> 2;
        out = cache_mem[replace_way][index].data;
        lru[index] = replace_way ^ 1;
        $display("Cache Miss: Way=%d, Index=%d, Data=0x%x", replace_way, index, out);
      end
    end
  end

endmodule