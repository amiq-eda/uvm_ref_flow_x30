//File24 name   : alut24.v
//Title24       : ALUT24 top level
//Created24     : 1999
//Description24 : 
//Notes24       : 
//----------------------------------------------------------------------
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------
module alut24
(   
   // Inputs24
   pclk24,
   n_p_reset24,
   psel24,            
   penable24,       
   pwrite24,         
   paddr24,           
   pwdata24,          

   // Outputs24
   prdata24  
);

   parameter   DW24 = 83;          // width of data busses24
   parameter   DD24 = 256;         // depth of RAM24


   // APB24 Inputs24
   input             pclk24;               // APB24 clock24                          
   input             n_p_reset24;          // Reset24                              
   input             psel24;               // Module24 select24 signal24               
   input             penable24;            // Enable24 signal24                      
   input             pwrite24;             // Write when HIGH24 and read when LOW24  
   input [6:0]       paddr24;              // Address bus for read write         
   input [31:0]      pwdata24;             // APB24 write bus                      

   output [31:0]     prdata24;             // APB24 read bus                       

   wire              pclk24;               // APB24 clock24                           
   wire [7:0]        mem_addr_add24;       // hash24 address for R/W24 to memory     
   wire              mem_write_add24;      // R/W24 flag24 (write = high24)            
   wire [DW24-1:0]     mem_write_data_add24; // write data for memory             
   wire [7:0]        mem_addr_age24;       // hash24 address for R/W24 to memory     
   wire              mem_write_age24;      // R/W24 flag24 (write = high24)            
   wire [DW24-1:0]     mem_write_data_age24; // write data for memory             
   wire [DW24-1:0]     mem_read_data_add24;  // read data from mem                 
   wire [DW24-1:0]     mem_read_data_age24;  // read data from mem  
   wire [31:0]       curr_time24;          // current time
   wire              active;             // status[0] adress24 checker active
   wire              inval_in_prog24;      // status[1] 
   wire              reused24;             // status[2] ALUT24 location24 overwritten24
   wire [4:0]        d_port24;             // calculated24 destination24 port for tx24
   wire [47:0]       lst_inv_addr_nrm24;   // last invalidated24 addr normal24 op
   wire [1:0]        lst_inv_port_nrm24;   // last invalidated24 port normal24 op
   wire [47:0]       lst_inv_addr_cmd24;   // last invalidated24 addr via cmd24
   wire [1:0]        lst_inv_port_cmd24;   // last invalidated24 port via cmd24
   wire [47:0]       mac_addr24;           // address of the switch24
   wire [47:0]       d_addr24;             // address of frame24 to be checked24
   wire [47:0]       s_addr24;             // address of frame24 to be stored24
   wire [1:0]        s_port24;             // source24 port of current frame24
   wire [31:0]       best_bfr_age24;       // best24 before age24
   wire [7:0]        div_clk24;            // programmed24 clock24 divider24 value
   wire [1:0]        command;            // command bus
   wire [31:0]       prdata24;             // APB24 read bus
   wire              age_confirmed24;      // valid flag24 from age24 checker        
   wire              age_ok24;             // result from age24 checker 
   wire              clear_reused24;       // read/clear flag24 for reused24 signal24           
   wire              check_age24;          // request flag24 for age24 check
   wire [31:0]       last_accessed24;      // time field sent24 for age24 check




alut_reg_bank24 i_alut_reg_bank24
(   
   // Inputs24
   .pclk24(pclk24),
   .n_p_reset24(n_p_reset24),
   .psel24(psel24),            
   .penable24(penable24),       
   .pwrite24(pwrite24),         
   .paddr24(paddr24),           
   .pwdata24(pwdata24),          
   .curr_time24(curr_time24),
   .add_check_active24(add_check_active24),
   .age_check_active24(age_check_active24),
   .inval_in_prog24(inval_in_prog24),
   .reused24(reused24),
   .d_port24(d_port24),
   .lst_inv_addr_nrm24(lst_inv_addr_nrm24),
   .lst_inv_port_nrm24(lst_inv_port_nrm24),
   .lst_inv_addr_cmd24(lst_inv_addr_cmd24),
   .lst_inv_port_cmd24(lst_inv_port_cmd24),

   // Outputs24
   .mac_addr24(mac_addr24),    
   .d_addr24(d_addr24),   
   .s_addr24(s_addr24),    
   .s_port24(s_port24),    
   .best_bfr_age24(best_bfr_age24),
   .div_clk24(div_clk24),     
   .command(command), 
   .prdata24(prdata24),  
   .clear_reused24(clear_reused24)           
);


alut_addr_checker24 i_alut_addr_checker24
(   
   // Inputs24
   .pclk24(pclk24),
   .n_p_reset24(n_p_reset24),
   .command(command),
   .mac_addr24(mac_addr24),
   .d_addr24(d_addr24),
   .s_addr24(s_addr24),
   .s_port24(s_port24),
   .curr_time24(curr_time24),
   .mem_read_data_add24(mem_read_data_add24),
   .age_confirmed24(age_confirmed24),
   .age_ok24(age_ok24),
   .clear_reused24(clear_reused24),

   //outputs24
   .d_port24(d_port24),
   .add_check_active24(add_check_active24),
   .mem_addr_add24(mem_addr_add24),
   .mem_write_add24(mem_write_add24),
   .mem_write_data_add24(mem_write_data_add24),
   .lst_inv_addr_nrm24(lst_inv_addr_nrm24),
   .lst_inv_port_nrm24(lst_inv_port_nrm24),
   .check_age24(check_age24),
   .last_accessed24(last_accessed24),
   .reused24(reused24)
);


alut_age_checker24 i_alut_age_checker24
(   
   // Inputs24
   .pclk24(pclk24),
   .n_p_reset24(n_p_reset24),
   .command(command),          
   .div_clk24(div_clk24),          
   .mem_read_data_age24(mem_read_data_age24),
   .check_age24(check_age24),        
   .last_accessed24(last_accessed24), 
   .best_bfr_age24(best_bfr_age24),   
   .add_check_active24(add_check_active24),

   // outputs24
   .curr_time24(curr_time24),         
   .mem_addr_age24(mem_addr_age24),      
   .mem_write_age24(mem_write_age24),     
   .mem_write_data_age24(mem_write_data_age24),
   .lst_inv_addr_cmd24(lst_inv_addr_cmd24),  
   .lst_inv_port_cmd24(lst_inv_port_cmd24),  
   .age_confirmed24(age_confirmed24),     
   .age_ok24(age_ok24),
   .inval_in_prog24(inval_in_prog24),            
   .age_check_active24(age_check_active24)
);   


alut_mem24 i_alut_mem24
(   
   // Inputs24
   .pclk24(pclk24),
   .mem_addr_add24(mem_addr_add24),
   .mem_write_add24(mem_write_add24),
   .mem_write_data_add24(mem_write_data_add24),
   .mem_addr_age24(mem_addr_age24),
   .mem_write_age24(mem_write_age24),
   .mem_write_data_age24(mem_write_data_age24),

   .mem_read_data_add24(mem_read_data_add24),  
   .mem_read_data_age24(mem_read_data_age24)
);   



`ifdef ABV_ON24
// psl24 default clock24 = (posedge pclk24);

// ASSUMPTIONS24

// ASSERTION24 CHECKS24
// the invalidate24 aged24 in progress24 flag24 and the active flag24 
// should never both be set.
// psl24 assert_inval_in_prog_active24 : assert never (inval_in_prog24 & active);

// it should never be possible24 for the destination24 port to indicate24 the MAC24
// switch24 address and one of the other 4 Ethernets24
// psl24 assert_valid_dest_port24 : assert never (d_port24[4] & |{d_port24[3:0]});

// COVER24 SANITY24 CHECKS24
// check all values of destination24 port can be returned.
// psl24 cover_d_port_024 : cover { d_port24 == 5'b0_0001 };
// psl24 cover_d_port_124 : cover { d_port24 == 5'b0_0010 };
// psl24 cover_d_port_224 : cover { d_port24 == 5'b0_0100 };
// psl24 cover_d_port_324 : cover { d_port24 == 5'b0_1000 };
// psl24 cover_d_port_424 : cover { d_port24 == 5'b1_0000 };
// psl24 cover_d_port_all24 : cover { d_port24 == 5'b0_1111 };

`endif


endmodule
