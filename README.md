## MessagingMacros
Even if you do _not_ have a UVM testbench, you should consider using `uvm_error()` instead of $error.
<br>
[dave_59](https://verificationacademy.com/forums/systemverilog/difference-between-uvmerror-and-error)

SystemVerilog macros to integrate the [UVM Messaging Service](https://cluelogic.com/2015/05/uvm-tutorial-for-candy-lovers-message-logging/) into non-UVM environments.
Four macros are defined, one for each of the popular UVM messaging service macros:
```
cvv_info(ID, MSG, SEV)
cvv_warning(ID, MSG)
cvv_error(ID, MSG)
cvv_fatal(UD, MSG)
```
This repo also passes as an indirect test of Verilator's ability to compile the entire UVM library and run the UVM messaging service.

### To run it:
1. Install the latest version of Verilator.  This code has been tested with v5.018.
2. Clone Antmicro's version of the UVM library from git@github.com:antmicro/uvm-verilator and point to it with the UVM_HOME shell environment variable.
3. The default target in the Makefile will do the trick:
```
$ make
```
Note that the UVM library takes several minutes to "verilate".
