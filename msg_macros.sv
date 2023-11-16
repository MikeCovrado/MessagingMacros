module msg_macros;

`include "uvm_macros.svh"
import uvm_pkg::*;

logic       tb_clk;
string      my_id;

`define cvv_info(ID, MSG, SEV) \
  `ifdef UVM \
    `uvm_info(ID, MSG, SEV) \
  `else \
    $display("CORE-V-VERIF INFO @ %0t [%0s]: %0s", $time, ID, MSG); \
  `endif

`define cvv_warning(ID, MSG) \
  `ifdef UVM \
    `uvm_warning(ID, MSG) \
  `else \
    $warning("CORE-V-VERIF WARNING @ %0t [%0s]: %0s", $time, ID, MSG); \
  `endif

`define cvv_error(ID, MSG) \
  `ifdef UVM \
    `uvm_error(ID, MSG) \
  `else \
    $display("CORE-V-VERIF ERROR @ %0t [%0s]: %0s", $time, ID, MSG); \
  `endif

`define cvv_fatal(ID, MSG) \
  `ifdef UVM \
    `uvm_fatal(ID, MSG) \
  `else \
    `ifdef VERILATOR \
      $display("CORE-V-VERIF ERROR @ %0t [%0s]: %0s", $time, ID, MSG); \
    `else \
      $fatal("CORE-V-VERIF FATAL @ %0t [%0s]: %0s", $time, ID, MSG); \
    `endif \
  `endif

initial begin
  $timeformat(-9, 0, "ns", 9);
  my_id  = "ERROR_MACROS";
  tb_clk = 1;
  fork
    forever begin
      #5 tb_clk = ~tb_clk;
    end
    begin
      repeat (100) @(negedge tb_clk);
      `cvv_fatal(my_id, "That's all folks!\n")
    end
  join
end

always @(posedge tb_clk) begin
  `cvv_info(my_id, "tb_clk", UVM_NONE)
end

initial begin
  repeat (20) @(posedge tb_clk);
  `cvv_info(my_id, "this is information", UVM_NONE)
  repeat (20) @(posedge tb_clk);
  `cvv_warning(my_id, "I'm *warning* you!")
  repeat (20) @(posedge tb_clk);
  `cvv_error(my_id, "This is a bug")
end

endmodule: msg_macros
