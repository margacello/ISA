vcom -reportprogress 30 -work work /home/lp17.14/LP_project/DCT_1D_A/modelsim/resources.vhdl
vcom -reportprogress 30 -work work /home/lp17.14/LP_project/DCT_1D_A/modelsim/Adder.vhdl
vcom -reportprogress 30 -work work /home/lp17.14/LP_project/DCT_1D_A/modelsim/Multiplier.vhdl
vcom -reportprogress 30 -work work /home/lp17.14/LP_project/DCT_1D_A/modelsim/Register.vhdl
vcom -reportprogress 30 -work work /home/lp17.14/LP_project/DCT_1D_A/modelsim/ShiftRegister.vhdl
vcom -reportprogress 30 -work work /home/lp17.14/LP_project/DCT_1D_A/modelsim/IIR.vhdl
vcom -reportprogress 30 -work work /home/lp17.14/LP_project/DCT_1D_A/modelsim/IIR_TB.vhdl

vsim -t ns -novopt work.iir_tb

add wave -divider INPUTs
add wave -color yellow sim:/iir_tb/uut/clk
add wave -color yellow sim:/iir_tb/uut/rst_n
add wave -color green sim:/iir_tb/uut/v_in
add wave -radix decimal -color green sim:/iir_tb/uut/d_in

add wave -divider LOAD
add wave -radix binary -color yellow sim:/iir_tb/uut/sLOAD

add wave -divider OUTPUTs
add wave -color red sim:/iir_tb/uut/v_out
add wave -color red sim:/iir_tb/uut/d_out

add wave -divider ADDERs
add wave -radix unsigned -color yellow sim:/iir_tb/uut/dp/sADD_SUB 
add wave -radix decimal -color blue sim:/iir_tb/uut/dp/sIN_1_ADD
add wave -radix decimal -color green sim:/iir_tb/uut/sIN_2_ADD 
add wave -radix decimal -color magenta sim:/iir_tb/uut/sOUT_ADD

add wave -divider MULTs
add wave -radix decimal -color blue sim:/iir_tb/uut/dp/sIN_MULT
add wave -radix decimal -color green sim:/iir_tb/uut/sIN_C_MULT
add wave -radix decimal -color magenta sim:/iir_tb/uut/sOUT_MULT

add wave -divider INTERNAL_REGISTERS
add wave -radix decimal -color green sim:/iir_tb/uut/dp/sIN_REG
add wave -radix decimal -color magenta sim:/iir_tb/uut/sOUT_REG

run 100 ns