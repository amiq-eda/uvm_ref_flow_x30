//File13 name   : alut13.v
//Title13       : ALUT13 top level
//Created13     : 1999
//Description13 : 
//Notes13       : 
//----------------------------------------------------------------------
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------
module alut13
(   
   // Inputs13
   pclk13,
   n_p_reset13,
   psel13,            
   penable13,       
   pwrite13,         
   paddr13,           
   pwdata13,          

   // Outputs13
   prdata13  
);

   parameter   DW13 = 83;          // width of data busses13
   parameter   DD13 = 256;         // depth of RAM13


   // APB13 Inputs13
   input             pclk13;               // APB13 clock13                          
   input             n_p_reset13;          // Reset13                              
   input             psel13;               // Module13 select13 signal13               
   input             penable13;            // Enable13 signal13                      
   input             pwrite13;             // Write when HIGH13 and read when LOW13  
   input [6:0]       paddr13;              // Address bus for read write         
   input [31:0]      pwdata13;             // APB13 write bus                      

   output [31:0]     prdata13;             // APB13 read bus                       

   wire              pclk13;               // APB13 clock13                           
   wire [7:0]        mem_addr_add13;       // hash13 address for R/W13 to memory     
   wire              mem_write_add13;      // R/W13 flag13 (write = high13)            
   wire [DW13-1:0]     mem_write_data_add13; // write data for memory             
   wire [7:0]        mem_addr_age13;       // hash13 address for R/W13 to memory     
   wire              mem_write_age13;      // R/W13 flag13 (write = high13)            
   wire [DW13-1:0]     mem_write_data_age13; // write data for memory             
   wire [DW13-1:0]     mem_read_data_add13;  // read data from mem                 
   wire [DW13-1:0]     mem_read_data_age13;  // read data from mem  
   wire [31:0]       curr_time13;          // current time
   wire              active;             // status[0] adress13 checker active
   wire              inval_in_prog13;      // status[1] 
   wire              reused13;             // status[2] ALUT13 location13 overwritten13
   wire [4:0]        d_port13;             // calculated13 destination13 port for tx13
   wire [47:0]       lst_inv_addr_nrm13;   // last invalidated13 addr normal13 op
   wire [1:0]        lst_inv_port_nrm13;   // last invalidated13 port normal13 op
   wire [47:0]       lst_inv_addr_cmd13;   // last invalidated13 addr via cmd13
   wire [1:0]        lst_inv_port_cmd13;   // last invalidated13 port via cmd13
   wire [47:0]       mac_addr13;           // address of the switch13
   wire [47:0]       d_addr13;             // address of frame13 to be checked13
   wire [47:0]       s_addr13;             // address of frame13 to be stored13
   wire [1:0]        s_port13;             // source13 port of current frame13
   wire [31:0]       best_bfr_age13;       // best13 before age13
   wire [7:0]        div_clk13;            // programmed13 clock13 divider13 value
   wire [1:0]        command;            // command bus
   wire [31:0]       prdata13;             // APB13 read bus
   wire              age_confirmed13;      // valid flag13 from age13 checker        
   wire              age_ok13;             // result from age13 checker 
   wire              clear_reused13;       // read/clear flag13 for reused13 signal13           
   wire              check_age13;          // request flag13 for age13 check
   wire [31:0]       last_accessed13;      // time field sent13 for age13 check




alut_reg_bank13 i_alut_reg_bank13
(   
   // Inputs13
   .pclk13(pclk13),
   .n_p_reset13(n_p_reset13),
   .psel13(psel13),            
   .penable13(penable13),       
   .pwrite13(pwrite13),         
   .paddr13(paddr13),           
   .pwdata13(pwdata13),          
   .curr_time13(curr_time13),
   .add_check_active13(add_check_active13),
   .age_check_active13(age_check_active13),
   .inval_in_prog13(inval_in_prog13),
   .reused13(reused13),
   .d_port13(d_port13),
   .lst_inv_addr_nrm13(lst_inv_addr_nrm13),
   .lst_inv_port_nrm13(lst_inv_port_nrm13),
   .lst_inv_addr_cmd13(lst_inv_addr_cmd13),
   .lst_inv_port_cmd13(lst_inv_port_cmd13),

   // Outputs13
   .mac_addr13(mac_addr13),    
   .d_addr13(d_addr13),   
   .s_addr13(s_addr13),    
   .s_port13(s_port13),    
   .best_bfr_age13(best_bfr_age13),
   .div_clk13(div_clk13),     
   .command(command), 
   .prdata13(prdata13),  
   .clear_reused13(clear_reused13)           
);


alut_addr_checker13 i_alut_addr_checker13
(   
   // Inputs13
   .pclk13(pclk13),
   .n_p_reset13(n_p_reset13),
   .command(command),
   .mac_addr13(mac_addr13),
   .d_addr13(d_addr13),
   .s_addr13(s_addr13),
   .s_port13(s_port13),
   .curr_time13(curr_time13),
   .mem_read_data_add13(mem_read_data_add13),
   .age_confirmed13(age_confirmed13),
   .age_ok13(age_ok13),
   .clear_reused13(clear_reused13),

   //outputs13
   .d_port13(d_port13),
   .add_check_active13(add_check_active13),
   .mem_addr_add13(mem_addr_add13),
   .mem_write_add13(mem_write_add13),
   .mem_write_data_add13(mem_write_data_add13),
   .lst_inv_addr_nrm13(lst_inv_addr_nrm13),
   .lst_inv_port_nrm13(lst_inv_port_nrm13),
   .check_age13(check_age13),
   .last_accessed13(last_accessed13),
   .reused13(reused13)
);


alut_age_checker13 i_alut_age_checker13
(   
   // Inputs13
   .pclk13(pclk13),
   .n_p_reset13(n_p_reset13),
   .command(command),          
   .div_clk13(div_clk13),          
   .mem_read_data_age13(mem_read_data_age13),
   .check_age13(check_age13),        
   .last_accessed13(last_accessed13), 
   .best_bfr_age13(best_bfr_age13),   
   .add_check_active13(add_check_active13),

   // outputs13
   .curr_time13(curr_time13),         
   .mem_addr_age13(mem_addr_age13),      
   .mem_write_age13(mem_write_age13),     
   .mem_write_data_age13(mem_write_data_age13),
   .lst_inv_addr_cmd13(lst_inv_addr_cmd13),  
   .lst_inv_port_cmd13(lst_inv_port_cmd13),  
   .age_confirmed13(age_confirmed13),     
   .age_ok13(age_ok13),
   .inval_in_prog13(inval_in_prog13),            
   .age_check_active13(age_check_active13)
);   


alut_mem13 i_alut_mem13
(   
   // Inputs13
   .pclk13(pclk13),
   .mem_addr_add13(mem_addr_add13),
   .mem_write_add13(mem_write_add13),
   .mem_write_data_add13(mem_write_data_add13),
   .mem_addr_age13(mem_addr_age13),
   .mem_write_age13(mem_write_age13),
   .mem_write_data_age13(mem_write_data_age13),

   .mem_read_data_add13(mem_read_data_add13),  
   .mem_read_data_age13(mem_read_data_age13)
);   



`ifdef ABV_ON13
// psl13 default clock13 = (posedge pclk13);

// ASSUMPTIONS13

// ASSERTION13 CHECKS13
// the invalidate13 aged13 in progress13 flag13 and the active flag13 
// should never both be set.
// psl13 assert_inval_in_prog_active13 : assert never (inval_in_prog13 & active);

// it should never be possible13 for the destination13 port to indicate13 the MAC13
// switch13 address and one of the other 4 Ethernets13
// psl13 assert_valid_dest_port13 : assert never (d_port13[4] & |{d_port13[3:0]});

// COVER13 SANITY13 CHECKS13
// check all values of destination13 port can be returned.
// psl13 cover_d_port_013 : cover { d_port13 == 5'b0_0001 };
// psl13 cover_d_port_113 : cover { d_port13 == 5'b0_0010 };
// psl13 cover_d_port_213 : cover { d_port13 == 5'b0_0100 };
// psl13 cover_d_port_313 : cover { d_port13 == 5'b0_1000 };
// psl13 cover_d_port_413 : cover { d_port13 == 5'b1_0000 };
// psl13 cover_d_port_all13 : cover { d_port13 == 5'b0_1111 };

`endif


endmodule
