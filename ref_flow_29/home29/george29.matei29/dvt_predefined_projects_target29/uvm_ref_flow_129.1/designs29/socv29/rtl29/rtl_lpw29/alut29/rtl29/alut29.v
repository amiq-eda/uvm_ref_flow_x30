//File29 name   : alut29.v
//Title29       : ALUT29 top level
//Created29     : 1999
//Description29 : 
//Notes29       : 
//----------------------------------------------------------------------
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------
module alut29
(   
   // Inputs29
   pclk29,
   n_p_reset29,
   psel29,            
   penable29,       
   pwrite29,         
   paddr29,           
   pwdata29,          

   // Outputs29
   prdata29  
);

   parameter   DW29 = 83;          // width of data busses29
   parameter   DD29 = 256;         // depth of RAM29


   // APB29 Inputs29
   input             pclk29;               // APB29 clock29                          
   input             n_p_reset29;          // Reset29                              
   input             psel29;               // Module29 select29 signal29               
   input             penable29;            // Enable29 signal29                      
   input             pwrite29;             // Write when HIGH29 and read when LOW29  
   input [6:0]       paddr29;              // Address bus for read write         
   input [31:0]      pwdata29;             // APB29 write bus                      

   output [31:0]     prdata29;             // APB29 read bus                       

   wire              pclk29;               // APB29 clock29                           
   wire [7:0]        mem_addr_add29;       // hash29 address for R/W29 to memory     
   wire              mem_write_add29;      // R/W29 flag29 (write = high29)            
   wire [DW29-1:0]     mem_write_data_add29; // write data for memory             
   wire [7:0]        mem_addr_age29;       // hash29 address for R/W29 to memory     
   wire              mem_write_age29;      // R/W29 flag29 (write = high29)            
   wire [DW29-1:0]     mem_write_data_age29; // write data for memory             
   wire [DW29-1:0]     mem_read_data_add29;  // read data from mem                 
   wire [DW29-1:0]     mem_read_data_age29;  // read data from mem  
   wire [31:0]       curr_time29;          // current time
   wire              active;             // status[0] adress29 checker active
   wire              inval_in_prog29;      // status[1] 
   wire              reused29;             // status[2] ALUT29 location29 overwritten29
   wire [4:0]        d_port29;             // calculated29 destination29 port for tx29
   wire [47:0]       lst_inv_addr_nrm29;   // last invalidated29 addr normal29 op
   wire [1:0]        lst_inv_port_nrm29;   // last invalidated29 port normal29 op
   wire [47:0]       lst_inv_addr_cmd29;   // last invalidated29 addr via cmd29
   wire [1:0]        lst_inv_port_cmd29;   // last invalidated29 port via cmd29
   wire [47:0]       mac_addr29;           // address of the switch29
   wire [47:0]       d_addr29;             // address of frame29 to be checked29
   wire [47:0]       s_addr29;             // address of frame29 to be stored29
   wire [1:0]        s_port29;             // source29 port of current frame29
   wire [31:0]       best_bfr_age29;       // best29 before age29
   wire [7:0]        div_clk29;            // programmed29 clock29 divider29 value
   wire [1:0]        command;            // command bus
   wire [31:0]       prdata29;             // APB29 read bus
   wire              age_confirmed29;      // valid flag29 from age29 checker        
   wire              age_ok29;             // result from age29 checker 
   wire              clear_reused29;       // read/clear flag29 for reused29 signal29           
   wire              check_age29;          // request flag29 for age29 check
   wire [31:0]       last_accessed29;      // time field sent29 for age29 check




alut_reg_bank29 i_alut_reg_bank29
(   
   // Inputs29
   .pclk29(pclk29),
   .n_p_reset29(n_p_reset29),
   .psel29(psel29),            
   .penable29(penable29),       
   .pwrite29(pwrite29),         
   .paddr29(paddr29),           
   .pwdata29(pwdata29),          
   .curr_time29(curr_time29),
   .add_check_active29(add_check_active29),
   .age_check_active29(age_check_active29),
   .inval_in_prog29(inval_in_prog29),
   .reused29(reused29),
   .d_port29(d_port29),
   .lst_inv_addr_nrm29(lst_inv_addr_nrm29),
   .lst_inv_port_nrm29(lst_inv_port_nrm29),
   .lst_inv_addr_cmd29(lst_inv_addr_cmd29),
   .lst_inv_port_cmd29(lst_inv_port_cmd29),

   // Outputs29
   .mac_addr29(mac_addr29),    
   .d_addr29(d_addr29),   
   .s_addr29(s_addr29),    
   .s_port29(s_port29),    
   .best_bfr_age29(best_bfr_age29),
   .div_clk29(div_clk29),     
   .command(command), 
   .prdata29(prdata29),  
   .clear_reused29(clear_reused29)           
);


alut_addr_checker29 i_alut_addr_checker29
(   
   // Inputs29
   .pclk29(pclk29),
   .n_p_reset29(n_p_reset29),
   .command(command),
   .mac_addr29(mac_addr29),
   .d_addr29(d_addr29),
   .s_addr29(s_addr29),
   .s_port29(s_port29),
   .curr_time29(curr_time29),
   .mem_read_data_add29(mem_read_data_add29),
   .age_confirmed29(age_confirmed29),
   .age_ok29(age_ok29),
   .clear_reused29(clear_reused29),

   //outputs29
   .d_port29(d_port29),
   .add_check_active29(add_check_active29),
   .mem_addr_add29(mem_addr_add29),
   .mem_write_add29(mem_write_add29),
   .mem_write_data_add29(mem_write_data_add29),
   .lst_inv_addr_nrm29(lst_inv_addr_nrm29),
   .lst_inv_port_nrm29(lst_inv_port_nrm29),
   .check_age29(check_age29),
   .last_accessed29(last_accessed29),
   .reused29(reused29)
);


alut_age_checker29 i_alut_age_checker29
(   
   // Inputs29
   .pclk29(pclk29),
   .n_p_reset29(n_p_reset29),
   .command(command),          
   .div_clk29(div_clk29),          
   .mem_read_data_age29(mem_read_data_age29),
   .check_age29(check_age29),        
   .last_accessed29(last_accessed29), 
   .best_bfr_age29(best_bfr_age29),   
   .add_check_active29(add_check_active29),

   // outputs29
   .curr_time29(curr_time29),         
   .mem_addr_age29(mem_addr_age29),      
   .mem_write_age29(mem_write_age29),     
   .mem_write_data_age29(mem_write_data_age29),
   .lst_inv_addr_cmd29(lst_inv_addr_cmd29),  
   .lst_inv_port_cmd29(lst_inv_port_cmd29),  
   .age_confirmed29(age_confirmed29),     
   .age_ok29(age_ok29),
   .inval_in_prog29(inval_in_prog29),            
   .age_check_active29(age_check_active29)
);   


alut_mem29 i_alut_mem29
(   
   // Inputs29
   .pclk29(pclk29),
   .mem_addr_add29(mem_addr_add29),
   .mem_write_add29(mem_write_add29),
   .mem_write_data_add29(mem_write_data_add29),
   .mem_addr_age29(mem_addr_age29),
   .mem_write_age29(mem_write_age29),
   .mem_write_data_age29(mem_write_data_age29),

   .mem_read_data_add29(mem_read_data_add29),  
   .mem_read_data_age29(mem_read_data_age29)
);   



`ifdef ABV_ON29
// psl29 default clock29 = (posedge pclk29);

// ASSUMPTIONS29

// ASSERTION29 CHECKS29
// the invalidate29 aged29 in progress29 flag29 and the active flag29 
// should never both be set.
// psl29 assert_inval_in_prog_active29 : assert never (inval_in_prog29 & active);

// it should never be possible29 for the destination29 port to indicate29 the MAC29
// switch29 address and one of the other 4 Ethernets29
// psl29 assert_valid_dest_port29 : assert never (d_port29[4] & |{d_port29[3:0]});

// COVER29 SANITY29 CHECKS29
// check all values of destination29 port can be returned.
// psl29 cover_d_port_029 : cover { d_port29 == 5'b0_0001 };
// psl29 cover_d_port_129 : cover { d_port29 == 5'b0_0010 };
// psl29 cover_d_port_229 : cover { d_port29 == 5'b0_0100 };
// psl29 cover_d_port_329 : cover { d_port29 == 5'b0_1000 };
// psl29 cover_d_port_429 : cover { d_port29 == 5'b1_0000 };
// psl29 cover_d_port_all29 : cover { d_port29 == 5'b0_1111 };

`endif


endmodule
