//File9 name   : alut9.v
//Title9       : ALUT9 top level
//Created9     : 1999
//Description9 : 
//Notes9       : 
//----------------------------------------------------------------------
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------
module alut9
(   
   // Inputs9
   pclk9,
   n_p_reset9,
   psel9,            
   penable9,       
   pwrite9,         
   paddr9,           
   pwdata9,          

   // Outputs9
   prdata9  
);

   parameter   DW9 = 83;          // width of data busses9
   parameter   DD9 = 256;         // depth of RAM9


   // APB9 Inputs9
   input             pclk9;               // APB9 clock9                          
   input             n_p_reset9;          // Reset9                              
   input             psel9;               // Module9 select9 signal9               
   input             penable9;            // Enable9 signal9                      
   input             pwrite9;             // Write when HIGH9 and read when LOW9  
   input [6:0]       paddr9;              // Address bus for read write         
   input [31:0]      pwdata9;             // APB9 write bus                      

   output [31:0]     prdata9;             // APB9 read bus                       

   wire              pclk9;               // APB9 clock9                           
   wire [7:0]        mem_addr_add9;       // hash9 address for R/W9 to memory     
   wire              mem_write_add9;      // R/W9 flag9 (write = high9)            
   wire [DW9-1:0]     mem_write_data_add9; // write data for memory             
   wire [7:0]        mem_addr_age9;       // hash9 address for R/W9 to memory     
   wire              mem_write_age9;      // R/W9 flag9 (write = high9)            
   wire [DW9-1:0]     mem_write_data_age9; // write data for memory             
   wire [DW9-1:0]     mem_read_data_add9;  // read data from mem                 
   wire [DW9-1:0]     mem_read_data_age9;  // read data from mem  
   wire [31:0]       curr_time9;          // current time
   wire              active;             // status[0] adress9 checker active
   wire              inval_in_prog9;      // status[1] 
   wire              reused9;             // status[2] ALUT9 location9 overwritten9
   wire [4:0]        d_port9;             // calculated9 destination9 port for tx9
   wire [47:0]       lst_inv_addr_nrm9;   // last invalidated9 addr normal9 op
   wire [1:0]        lst_inv_port_nrm9;   // last invalidated9 port normal9 op
   wire [47:0]       lst_inv_addr_cmd9;   // last invalidated9 addr via cmd9
   wire [1:0]        lst_inv_port_cmd9;   // last invalidated9 port via cmd9
   wire [47:0]       mac_addr9;           // address of the switch9
   wire [47:0]       d_addr9;             // address of frame9 to be checked9
   wire [47:0]       s_addr9;             // address of frame9 to be stored9
   wire [1:0]        s_port9;             // source9 port of current frame9
   wire [31:0]       best_bfr_age9;       // best9 before age9
   wire [7:0]        div_clk9;            // programmed9 clock9 divider9 value
   wire [1:0]        command;            // command bus
   wire [31:0]       prdata9;             // APB9 read bus
   wire              age_confirmed9;      // valid flag9 from age9 checker        
   wire              age_ok9;             // result from age9 checker 
   wire              clear_reused9;       // read/clear flag9 for reused9 signal9           
   wire              check_age9;          // request flag9 for age9 check
   wire [31:0]       last_accessed9;      // time field sent9 for age9 check




alut_reg_bank9 i_alut_reg_bank9
(   
   // Inputs9
   .pclk9(pclk9),
   .n_p_reset9(n_p_reset9),
   .psel9(psel9),            
   .penable9(penable9),       
   .pwrite9(pwrite9),         
   .paddr9(paddr9),           
   .pwdata9(pwdata9),          
   .curr_time9(curr_time9),
   .add_check_active9(add_check_active9),
   .age_check_active9(age_check_active9),
   .inval_in_prog9(inval_in_prog9),
   .reused9(reused9),
   .d_port9(d_port9),
   .lst_inv_addr_nrm9(lst_inv_addr_nrm9),
   .lst_inv_port_nrm9(lst_inv_port_nrm9),
   .lst_inv_addr_cmd9(lst_inv_addr_cmd9),
   .lst_inv_port_cmd9(lst_inv_port_cmd9),

   // Outputs9
   .mac_addr9(mac_addr9),    
   .d_addr9(d_addr9),   
   .s_addr9(s_addr9),    
   .s_port9(s_port9),    
   .best_bfr_age9(best_bfr_age9),
   .div_clk9(div_clk9),     
   .command(command), 
   .prdata9(prdata9),  
   .clear_reused9(clear_reused9)           
);


alut_addr_checker9 i_alut_addr_checker9
(   
   // Inputs9
   .pclk9(pclk9),
   .n_p_reset9(n_p_reset9),
   .command(command),
   .mac_addr9(mac_addr9),
   .d_addr9(d_addr9),
   .s_addr9(s_addr9),
   .s_port9(s_port9),
   .curr_time9(curr_time9),
   .mem_read_data_add9(mem_read_data_add9),
   .age_confirmed9(age_confirmed9),
   .age_ok9(age_ok9),
   .clear_reused9(clear_reused9),

   //outputs9
   .d_port9(d_port9),
   .add_check_active9(add_check_active9),
   .mem_addr_add9(mem_addr_add9),
   .mem_write_add9(mem_write_add9),
   .mem_write_data_add9(mem_write_data_add9),
   .lst_inv_addr_nrm9(lst_inv_addr_nrm9),
   .lst_inv_port_nrm9(lst_inv_port_nrm9),
   .check_age9(check_age9),
   .last_accessed9(last_accessed9),
   .reused9(reused9)
);


alut_age_checker9 i_alut_age_checker9
(   
   // Inputs9
   .pclk9(pclk9),
   .n_p_reset9(n_p_reset9),
   .command(command),          
   .div_clk9(div_clk9),          
   .mem_read_data_age9(mem_read_data_age9),
   .check_age9(check_age9),        
   .last_accessed9(last_accessed9), 
   .best_bfr_age9(best_bfr_age9),   
   .add_check_active9(add_check_active9),

   // outputs9
   .curr_time9(curr_time9),         
   .mem_addr_age9(mem_addr_age9),      
   .mem_write_age9(mem_write_age9),     
   .mem_write_data_age9(mem_write_data_age9),
   .lst_inv_addr_cmd9(lst_inv_addr_cmd9),  
   .lst_inv_port_cmd9(lst_inv_port_cmd9),  
   .age_confirmed9(age_confirmed9),     
   .age_ok9(age_ok9),
   .inval_in_prog9(inval_in_prog9),            
   .age_check_active9(age_check_active9)
);   


alut_mem9 i_alut_mem9
(   
   // Inputs9
   .pclk9(pclk9),
   .mem_addr_add9(mem_addr_add9),
   .mem_write_add9(mem_write_add9),
   .mem_write_data_add9(mem_write_data_add9),
   .mem_addr_age9(mem_addr_age9),
   .mem_write_age9(mem_write_age9),
   .mem_write_data_age9(mem_write_data_age9),

   .mem_read_data_add9(mem_read_data_add9),  
   .mem_read_data_age9(mem_read_data_age9)
);   



`ifdef ABV_ON9
// psl9 default clock9 = (posedge pclk9);

// ASSUMPTIONS9

// ASSERTION9 CHECKS9
// the invalidate9 aged9 in progress9 flag9 and the active flag9 
// should never both be set.
// psl9 assert_inval_in_prog_active9 : assert never (inval_in_prog9 & active);

// it should never be possible9 for the destination9 port to indicate9 the MAC9
// switch9 address and one of the other 4 Ethernets9
// psl9 assert_valid_dest_port9 : assert never (d_port9[4] & |{d_port9[3:0]});

// COVER9 SANITY9 CHECKS9
// check all values of destination9 port can be returned.
// psl9 cover_d_port_09 : cover { d_port9 == 5'b0_0001 };
// psl9 cover_d_port_19 : cover { d_port9 == 5'b0_0010 };
// psl9 cover_d_port_29 : cover { d_port9 == 5'b0_0100 };
// psl9 cover_d_port_39 : cover { d_port9 == 5'b0_1000 };
// psl9 cover_d_port_49 : cover { d_port9 == 5'b1_0000 };
// psl9 cover_d_port_all9 : cover { d_port9 == 5'b0_1111 };

`endif


endmodule
