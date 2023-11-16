#--- obj_dir is where all the compilation artifacts live
#--- results is where are the simulation outputs go
VERILATOR_OBJ_DIR ?= verilator_objs
VERILATOR_RESULTS ?= verilator_results

#--- SV Module name of the "top"
TOP_MODULE        ?= msg_macros

#--- Optional user arguments to verilator at compile time
USER_ARG          ?= +define+UVM

#--- Location of UVM sources (currently verilator only supports Antmicro implementation
UVM_HOME           = $(HOME)/GitHubRepos/antmicro/current-patches
UVM_SRC            = $(UVM_HOME)/src
UVM_PKG            = $(UVM_SRC)/uvm_pkg.sv

#--- Number of threads launched at compile time (careful!)
NJOBS             ?= 4

#--- Deliberately disabled warnings (all from the UVM class library)
DISABLED_WARNINGS = -Wno-DECLFILENAME \
                    -Wno-CONSTRAINTIGN \
                    -Wno-MISINDENT \
                    -Wno-VARHIDDEN \
                    -Wno-WIDTHTRUNC \
                    -Wno-CASTCONST \
                    -Wno-WIDTHEXPAND \
                    -Wno-UNDRIVEN \
                    -Wno-UNUSEDSIGNAL \
                    -Wno-UNUSEDPARAM \
                    -Wno-ZERODLY \
                    -Wno-SYMRSVDWORD \
                    -Wno-CASEINCOMPLETE \
                    -Wno-BLKSEQ \
                    -Wno-REALCVT

VERILATOR_DEBUG   = --debug \
                    --gdbbt

all: clean verilate run

clean:
	rm -rf $(VERILATOR_OBJ_DIR)
	rm -rf $(VERILATOR_RESULTS)

verilate:
	mkdir -p $(VERILATOR_RESULTS)
	verilator \
		--cc \
		--exe \
		--Mdir $(VERILATOR_OBJ_DIR) \
		--build \
		--binary \
		--hierarchical \
		-j $(NJOBS) \
		-Wall \
		--timing\
		--timescale 1ns/1ns \
		$(DISABLED_WARNINGS) \
		+define+UVM_REPORT_DISABLE_FILE_LINE \
		+define+SVA_ON \
		+define+UVM_NO_DPI \
		+incdir+$(UVM_SRC) \
		$(USER_ARG) \
		--top-module $(TOP_MODULE) \
		-o ../$(VERILATOR_RESULTS)/$(TOP_MODULE) \
		$(UVM_PKG) \
		$(TOP_MODULE).sv

run:
	cd $(VERILATOR_RESULTS) && \
	./$(TOP_MODULE) | tee $(TOP_MODULE).log
