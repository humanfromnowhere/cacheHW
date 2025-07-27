module tb;
  logic clk, rst;
  logic[31:0] addr;
  logic[31:0] out;
  logic hit;
  int tests = 0, errors = 0;

  cache dut(.addr(addr),
           .clk(clk),
           .rst(rst),
           .out(out),
           .hit(hit)
          );

  always #5 clk = ~clk;

  initial
    begin
      clk = 1'b0;
      rst = 1'b1;

      addr = 32'h24; #5
      tests = tests+1;
      $strobe("Result: hit = %1b, data = 0x%x", hit, out);
      if ( hit === 0 & out === 9 )
         $strobe("[Test Successfull... ]");
      else
        begin
          $strobe("[Test failed: Expected hit = %1b, data = 0x%x]", 0, 9);
          errors = errors+1;
        end #5

      addr = 32'h34; #5
      tests = tests+1;
      $strobe("Result: hit = %1b, data = 0x%x", hit, out);
      if ( hit === 0 & out === 13 )
         $strobe("[Test Successfull... ]");
      else
        begin
          $strobe("[Test failed: Expected hit = %1b, data = 0x%x]", 0, 13);
          errors = errors+1;
        end #5

      addr = 32'h24; #5
      tests = tests+1;
      $strobe("Result: hit = %1b, data = 0x%x", hit, out);
      if ( hit === 1 & out === 9 )
         $strobe("[Test Successfull... ]");
      else
        begin
          $strobe("[Test failed: Expected hit = %1b, data = 0x%x]", 1, 9);
          errors = errors+1;
        end #5

      addr = 32'h34; #5
      tests = tests+1;
      $strobe("Result: hit = %1b, data = 0x%x", hit, out);
      if ( hit === 1 & out === 13 )
         $strobe("[Test Successfull... ]");
      else
        begin
          $strobe("[Test failed: Expected hit = %1b, data = 0x%x]", 1, 13);
          errors = errors+1;
        end #5

      rst = 1'b0;
      #10
      rst = 1'b1;

      addr = 32'h24; #5
      tests = tests+1;
      $strobe("Result: hit = %1b, data = 0x%x", hit, out);
      if ( hit === 0 & out === 9 )
        $strobe("[Test Successfull... ]");
      else
        begin
          $strobe("[Test failed: Expected hit = %1b, data = 0x%x]", 0, 9);
          errors = errors+1;
        end #5

      $display("=========================================================== ");
      $display("\t Total tests:  %d\n", tests);
      $display("\t Total errors: %d\n", errors);
      $display("==================================================================");

      $finish;
    end
endmodule