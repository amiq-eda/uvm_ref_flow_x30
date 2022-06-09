//File6 name   : alut6.v
//Title6       : ALUT6 top level
//Created6     : 1999
//Description6 : 
//Notes6       : 
//----------------------------------------------------------------------
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------
module alut6
(   
   // Inputs6
   pclk6,
   n_p_reset6,
   psel6,            
   penable6,       
   pwrite6,         
   paddr6,           
   pwdata6,          

   // Outputs6
   prdata6  
);

   parameter   DW6 = 83;          // width of data busses6
   parameter   DD6 = 256;         // depth of RAM6


   // APB6 Inputs6
   input             pclk6;               // APB6 clock6                          
   input             n_p_reset6;          // Reset6                              
   input             psel6;               // Module6 select6 signal6               
   input             penable6;            // Enable6 signal6                      
   input             pwrite6;             // Write when HIGH6 and read when LOW6  
   input [6:0]       paddr6;              // Address bus for read write         
   input [31:0]      pwdata6;             // APB6 write bus                      

   output [31:0]     prdata6;             // APB6 read bus                       

   wire              pclk6;               // APB6 clock6                           
   wire [7:0]        mem_addr_add6;       // hash6 address for R/W6 to memory     
   wire              mem_write_add6;      // R/W6 flag6 (write = high6)            
   wire [DW6-1:0]     mem_write_data_add6; // write data for memory             
   wire [7:0]        mem_addr_age6;       // hash6 address for R/W6 to memory     
   wire              mem_write_age6;      // R/W6 flag6 (write = high6)            
   wire [DW6-1:0]     mem_write_data_age6; // write data for memory             
   wire [DW6-1:0]     mem_read_data_add6;  // read data from mem                 
   wire [DW6-1:0]     mem_read_data_age6;  // read data from mem  
   wire [31:0]       curr_time6;          // current time
   wire              active;             // status[0] adress6 checker active
   wire              inval_in_prog6;      // status[1] 
   wire              reused6;             // status[2] ALUT6 location6 overwritten6
   wire [4:0]        d_port6;             // calculated6 destination6 port for tx6
   wire [47:0]       lst_inv_addr_nrm6;   // last invalidated6 addr normal6 op
   wire [1:0]        lst_inv_port_nrm6;   // last invalidated6 port normal6 op
   wire [47:0]       lst_inv_addr_cmd6;   // last invalidated6 addr via cmd6
   wire [1:0]        lst_inv_port_cmd6;   // last invalidated6 port via cmd6
   wire [47:0]       mac_addr6;           // address of the switch6
   wire [47:0]       d_addr6;             // address of frame6 to be checked6
   wire [47:0]       s_addr6;             // address of frame6 to be stored6
   wire [1:0]        s_port6;             // source6 port of current frame6
   wire [31:0]       best_bfr_age6;       // best6 before age6
   wire [7:0]        div_clk6;            // programmed6 clock6 divider6 value
   wire [1:0]        command;            // command bus
   wire [31:0]       prdata6;             // APB6 read bus
   wire              age_confirmed6;      // valid flag6 from age6 checker        
   wire              age_ok6;             // result from age6 checker 
   wire              clear_reused6;       // read/clear flag6 for reused6 signal6           
   wire              check_age6;          // request flag6 for age6 check
   wire [31:0]       last_accessed6;      // time field sent6 for age6 check




alut_reg_bank6 i_alut_reg_bank6
(   
   // Inputs6
   .pclk6(pclk6),
   .n_p_reset6(n_p_reset6),
   .psel6(psel6),            
   .penable6(penable6),       
   .pwrite6(pwrite6),         
   .paddr6(paddr6),           
   .pwdata6(pwdata6),          
   .curr_time6(curr_time6),
   .add_check_active6(add_check_active6),
   .age_check_active6(age_check_active6),
   .inval_in_prog6(inval_in_prog6),
   .reused6(reused6),
   .d_port6(d_port6),
   .lst_inv_addr_nrm6(lst_inv_addr_nrm6),
   .lst_inv_port_nrm6(lst_inv_port_nrm6),
   .lst_inv_addr_cmd6(lst_inv_addr_cmd6),
   .lst_inv_port_cmd6(lst_inv_port_cmd6),

   // Outputs6
   .mac_addr6(mac_addr6),    
   .d_addr6(d_addr6),   
   .s_addr6(s_addr6),    
   .s_port6(s_port6),    
   .best_bfr_age6(best_bfr_age6),
   .div_clk6(div_clk6),     
   .command(command), 
   .prdata6(prdata6),  
   .clear_reused6(clear_reused6)           
);


alut_addr_checker6 i_alut_addr_checker6
(   
   // Inputs6
   .pclk6(pclk6),
   .n_p_reset6(n_p_reset6),
   .command(command),
   .mac_addr6(mac_addr6),
   .d_addr6(d_addr6),
   .s_addr6(s_addr6),
   .s_port6(s_port6),
   .curr_time6(curr_time6),
   .mem_read_data_add6(mem_read_data_add6),
   .age_confirmed6(age_confirmed6),
   .age_ok6(age_ok6),
   .clear_reused6(clear_reused6),

   //outputs6
   .d_port6(d_port6),
   .add_check_active6(add_check_active6),
   .mem_addr_add6(mem_addr_add6),
   .mem_write_add6(mem_write_add6),
   .mem_write_data_add6(mem_write_data_add6),
   .lst_inv_addr_nrm6(lst_inv_addr_nrm6),
   .lst_inv_port_nrm6(lst_inv_port_nrm6),
   .check_age6(check_age6),
   .last_accessed6(last_accessed6),
   .reused6(reused6)
);


alut_age_checker6 i_alut_age_checker6
(   
   // Inputs6
   .pclk6(pclk6),
   .n_p_reset6(n_p_reset6),
   .command(command),          
   .div_clk6(div_clk6),          
   .mem_read_data_age6(mem_read_data_age6),
   .check_age6(check_age6),        
   .last_accessed6(last_accessed6), 
   .best_bfr_age6(best_bfr_age6),   
   .add_check_active6(add_check_active6),

   // outputs6
   .curr_time6(curr_time6),         
   .mem_addr_age6(mem_addr_age6),      
   .mem_write_age6(mem_write_age6),     
   .mem_write_data_age6(mem_write_data_age6),
   .lst_inv_addr_cmd6(lst_inv_addr_cmd6),  
   .lst_inv_port_cmd6(lst_inv_port_cmd6),  
   .age_confirmed6(age_confirmed6),     
   .age_ok6(age_ok6),
   .inval_in_prog6(inval_in_prog6),            
   .age_check_active6(age_check_active6)
);   


alut_mem6 i_alut_mem6
(   
   // Inputs6
   .pclk6(pclk6),
   .mem_addr_add6(mem_addr_add6),
   .mem_write_add6(mem_write_add6),
   .mem_write_data_add6(mem_write_data_add6),
   .mem_addr_age6(mem_addr_age6),
   .mem_write_age6(mem_write_age6),
   .mem_write_data_age6(mem_write_data_age6),

   .mem_read_data_add6(mem_read_data_add6),  
   .mem_read_data_age6(mem_read_data_age6)
);   



`ifdef ABV_ON6
// psl6 default clock6 = (posedge pclk6);

// ASSUMPTIONS6

// ASSERTION6 CHECKS6
// the invalidate6 aged6 in progress6 flag6 and the active flag6 
// should never both be set.
// psl6 assert_inval_in_prog_active6 : assert never (inval_in_prog6 & active);

// it should never be possible6 for the destination6 port to indicate6 the MAC6
// switch6 address and one of the other 4 Ethernets6
// psl6 assert_valid_dest_port6 : assert never (d_port6[4] & |{d_port6[3:0]});

// COVER6 SANITY6 CHECKS6
// check all values of destination6 port can be returned.
// psl6 cover_d_port_06 : cover { d_port6 == 5'b0_0001 };
// psl6 cover_d_port_16 : cover { d_port6 == 5'b0_0010 };
// psl6 cover_d_port_26 : cover { d_port6 == 5'b0_0100 };
// psl6 cover_d_port_36 : cover { d_port6 == 5'b0_1000 };
// psl6 cover_d_port_46 : cover { d_port6 == 5'b1_0000 };
// psl6 cover_d_port_all6 : cover { d_port6 == 5'b0_1111 };

`endif


endmodule
