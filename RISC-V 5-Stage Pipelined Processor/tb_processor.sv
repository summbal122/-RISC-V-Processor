module tb_processor();
    logic clk;
    logic rst;

    processor dut
    (
        .clk(clk),
        .rst(rst)
    );

    // Clock Generator
    initial
    begin
        clk = 0;
        forever
        begin
            #5 clk = ~clk;
        end
    end

    // Reset generator
    initial
    begin
        rst = 1;
        #10;
        rst = 0;
        #5000; // Increased time for instruction execution
        $finish;
    end

    initial //initializng csr file
    begin
        #10 rst = 0; // Deassert reset
    #5 $readmemb("csr_register_file", dut.csr_inst.csr_mem); // Initialize after reset
    end

    // Initializing memory
    initial
    begin
        $readmemb("instruction_memory", dut.imem.mem);
        $readmemb("register_file", dut.reg_file_inst.reg_mem);
        $readmemb("data_memory", dut.data_mem_inst.data_memory);
      
    end

    // Dumping output
    initial
    begin
        $dumpfile("processor.vcd");
        $dumpvars(0, tb_processor);
        $dumpvars(1, dut.reg_file_inst.reg_mem); // Dump register file values
        $dumpvars(2, dut.csr_inst.csr_mem);
    end

endmodule
