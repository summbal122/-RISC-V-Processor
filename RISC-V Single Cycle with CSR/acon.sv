module controller
(
    input  logic [ 6:0] opcode,
    input  logic [ 2:0] func3,
    input  logic [ 6:0] func7,
    output logic [ 3:0] aluop,
    output logic        rf_en,
    output logic        sel_B  // New signal to select between register (R-type) and immediate (I-type)
);

    always_comb
    begin
        case (opcode)
            7'b0110011:  // R-Type
            begin
                rf_en = 1'b1;
                sel_B = 1'b0;  // Select register (rs2) for R-type
                unique case (func3)
                    3'b000:
                    begin
                    unique case (func7)
                        7'b0000000: aluop = 4'b0000; // ADD
                        7'b0100000: aluop = 4'b0001; // SUB
                    endcase
                    end
                    3'b001: aluop = 4'b0010; //SLL
                    3'b010: aluop = 4'b0011; //SLT
                    3'b011: aluop = 4'b0100; //SLTU
                    3'b100: aluop = 4'b0101; //XOR
                    3'b101:
                    begin
                        unique case (func7)
                            7'b0000000:  aluop = 4'b0110; //SRL
                            7'b0100000:  aluop = 4'b0111; //SRA
                        endcase
                    end
                    3'b110: aluop = 4'b1000; //OR
                    3'b111: aluop = 4'b1001; //AND
                endcase
            end

            7'b0010011:  // I-Type (e.g., ADDI, ORI, ANDI)
            begin
                rf_en = 1'b1;
                sel_B = 1'b1;  // Select immediate for I-type
                unique case (func3)
                    3'b000: aluop = 4'b0000; // ADDI
                    3'b010: aluop = 4'b0011; // SLTI
                    3'b011: aluop = 4'b0100; // SLTIU
                    3'b100: aluop = 4'b0101; // XORI
                    3'b110: aluop = 4'b1000; // ORI
                    3'b111: aluop = 4'b1001; // ANDI
                    3'b001: aluop = 4'b0010; // SLLI
                    3'b101: 
                    begin
                        unique case (func7[5])  // Only the 6th bit matters for SRLI and SRAI
                            1'b0: aluop = 4'b0110; // SRLI
                            1'b1: aluop = 4'b0111; // SRAI
                        endcase
                    end
                endcase
            end
            
            default:
            begin
                rf_en = 1'b0;
                sel_B = 1'b0;
                aluop = 4'b0000;
            end
        endcase
    end
endmodule
