
cell open-mri:user:DDS:1.0 vib_nco {
	PHASE_DW 24
	OUT_DW 16
	USE_TAYLOR 1
	LUT_DW 9
	SIN_COS 1
	NEGATIVE_SINE 1
} {
	clk /pll_0/clk_out1
	S_AXIS_PHASE /marga/DDS_VIB_PHASE_AXIS 
	reset_n /rst_0/peripheral_aresetn
}

cell xilinx.com:ip:axis_subset_converter:1.1 real_selector_0 {
    S_TDATA_NUM_BYTES.VALUE_SRC USER
    M_TDATA_NUM_BYTES.VALUE_SRC USER
    S_TDATA_NUM_BYTES 2
    M_TDATA_NUM_BYTES 4
    TDATA_REMAP {16'b0, tdata[15:0]}
} {
    S_AXIS vib_nco/M_AXIS_OUT_COS
	aclk /pll_0/clk_out1
	aresetn /rst_0/peripheral_aresetn
}

cell xilinx.com:ip:axis_subset_converter:1.1 real_selector_1 {
    S_TDATA_NUM_BYTES.VALUE_SRC USER
    M_TDATA_NUM_BYTES.VALUE_SRC USER
    S_TDATA_NUM_BYTES 2
    M_TDATA_NUM_BYTES 4
    TDATA_REMAP {16'b0, tdata[15:0]}
} {
    S_AXIS /marga/VIB_AMPL_AXIS
	aclk /pll_0/clk_out1
	aresetn /rst_0/peripheral_aresetn
}

cell open-mri:user:complex_multiplier:1.0 vib_mult_0 {
  OPERAND_WIDTH_A 16
  OPERAND_WIDTH_B 16
  OPERAND_WIDTH_OUT 32
  BLOCKING 0
  STAGES 6
  ROUND_MODE 1
} {
    S_AXIS_A real_selector_0/M_AXIS
    S_AXIS_B real_selector_1/M_AXIS
	aclk /pll_0/clk_out1
	aresetn /rst_0/peripheral_aresetn
}

cell xilinx.com:ip:axis_subset_converter:1.1 vib_real_trunc_0 {
    S_TDATA_NUM_BYTES.VALUE_SRC USER
    M_TDATA_NUM_BYTES.VALUE_SRC USER
    S_TDATA_NUM_BYTES 8
    M_TDATA_NUM_BYTES 2
    TDATA_REMAP {tdata[31:16]}
} {
    S_AXIS vib_mult_0/M_AXIS_DOUT
    aclk /pll_0/clk_out1
    aresetn /rst_0/peripheral_aresetn
}