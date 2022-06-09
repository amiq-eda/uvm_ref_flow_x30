//File14 name   : alut14.v
//Title14       : ALUT14 top level
//Created14     : 1999
//Description14 : 
//Notes14       : 
//----------------------------------------------------------------------
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------
module alut14
(   
   // Inputs14
   pclk14,
   n_p_reset14,
   psel14,            
   penable14,       
   pwrite14,         
   paddr14,           
   pwdata14,          

   // Outputs14
   prdata14  
);

   parameter   DW14 = 83;          // width of data busses14
   parameter   DD14 = 256;         // depth of RAM14


   // APB14 Inputs14
   input             pclk14;               // APB14 clock14                          
   input             n_p_reset14;          // Reset14                              
   input             psel14;               // Module14 select14 signal14               
   input             penable14;            // Enable14 signal14                      
   input             pwrite14;             // Write when HIGH14 and read when LOW14  
   input [6:0]       paddr14;              // Address bus for read write         
   input [31:0]      pwdata14;             // APB14 write bus                      

   output [31:0]     prdata14;             // APB14 read bus                       

   wire              pclk14;               // APB14 clock14                           
   wire [7:0]        mem_addr_add14;       // hash14 address for R/W14 to memory     
   wire              mem_write_add14;      // R/W14 flag14 (write = high14)            
   wire [DW14-1:0]     mem_write_data_add14; // write data for memory             
   wire [7:0]        mem_addr_age14;       // hash14 address for R/W14 to memory     
   wire              mem_write_age14;      // R/W14 flag14 (write = high14)            
   wire [DW14-1:0]     mem_write_data_age14; // write data for memory             
   wire [DW14-1:0]     mem_read_data_add14;  // read data from mem                 
   wire [DW14-1:0]     mem_read_data_age14;  // read data from mem  
   wire [31:0]       curr_time14;          // current time
   wire              active;             // status[0] adress14 checker active
   wire              inval_in_prog14;      // status[1] 
   wire              reused14;             // status[2] ALUT14 location14 overwritten14
   wire [4:0]        d_port14;             // calculated14 destination14 port for tx14
   wire [47:0]       lst_inv_addr_nrm14;   // last invalidated14 addr normal14 op
   wire [1:0]        lst_inv_port_nrm14;   // last invalidated14 port normal14 op
   wire [47:0]       lst_inv_addr_cmd14;   // last invalidated14 addr via cmd14
   wire [1:0]        lst_inv_port_cmd14;   // last invalidated14 port via cmd14
   wire [47:0]       mac_addr14;           // address of the switch14
   wire [47:0]       d_addr14;             // address of frame14 to be checked14
   wire [47:0]       s_addr14;             // address of frame14 to be stored14
   wire [1:0]        s_port14;             // source14 port of current frame14
   wire [31:0]       best_bfr_age14;       // best14 before age14
   wire [7:0]        div_clk14;            // programmed14 clock14 divider14 value
   wire [1:0]        command;            // command bus
   wire [31:0]       prdata14;             // APB14 read bus
   wire              age_confirmed14;      // valid flag14 from age14 checker        
   wire              age_ok14;             // result from age14 checker 
   wire              clear_reused14;       // read/clear flag14 for reused14 signal14           
   wire              check_age14;          // request flag14 for age14 check
   wire [31:0]       last_accessed14;      // time field sent14 for age14 check




alut_reg_bank14 i_alut_reg_bank14
(   
   // Inputs14
   .pclk14(pclk14),
   .n_p_reset14(n_p_reset14),
   .psel14(psel14),            
   .penable14(penable14),       
   .pwrite14(pwrite14),         
   .paddr14(paddr14),           
   .pwdata14(pwdata14),          
   .curr_time14(curr_time14),
   .add_check_active14(add_check_active14),
   .age_check_active14(age_check_active14),
   .inval_in_prog14(inval_in_prog14),
   .reused14(reused14),
   .d_port14(d_port14),
   .lst_inv_addr_nrm14(lst_inv_addr_nrm14),
   .lst_inv_port_nrm14(lst_inv_port_nrm14),
   .lst_inv_addr_cmd14(lst_inv_addr_cmd14),
   .lst_inv_port_cmd14(lst_inv_port_cmd14),

   // Outputs14
   .mac_addr14(mac_addr14),    
   .d_addr14(d_addr14),   
   .s_addr14(s_addr14),    
   .s_port14(s_port14),    
   .best_bfr_age14(best_bfr_age14),
   .div_clk14(div_clk14),     
   .command(command), 
   .prdata14(prdata14),  
   .clear_reused14(clear_reused14)           
);


alut_addr_checker14 i_alut_addr_checker14
(   
   // Inputs14
   .pclk14(pclk14),
   .n_p_reset14(n_p_reset14),
   .command(command),
   .mac_addr14(mac_addr14),
   .d_addr14(d_addr14),
   .s_addr14(s_addr14),
   .s_port14(s_port14),
   .curr_time14(curr_time14),
   .mem_read_data_add14(mem_read_data_add14),
   .age_confirmed14(age_confirmed14),
   .age_ok14(age_ok14),
   .clear_reused14(clear_reused14),

   //outputs14
   .d_port14(d_port14),
   .add_check_active14(add_check_active14),
   .mem_addr_add14(mem_addr_add14),
   .mem_write_add14(mem_write_add14),
   .mem_write_data_add14(mem_write_data_add14),
   .lst_inv_addr_nrm14(lst_inv_addr_nrm14),
   .lst_inv_port_nrm14(lst_inv_port_nrm14),
   .check_age14(check_age14),
   .last_accessed14(last_accessed14),
   .reused14(reused14)
);


alut_age_checker14 i_alut_age_checker14
(   
   // Inputs14
   .pclk14(pclk14),
   .n_p_reset14(n_p_reset14),
   .command(command),          
   .div_clk14(div_clk14),          
   .mem_read_data_age14(mem_read_data_age14),
   .check_age14(check_age14),        
   .last_accessed14(last_accessed14), 
   .best_bfr_age14(best_bfr_age14),   
   .add_check_active14(add_check_active14),

   // outputs14
   .curr_time14(curr_time14),         
   .mem_addr_age14(mem_addr_age14),      
   .mem_write_age14(mem_write_age14),     
   .mem_write_data_age14(mem_write_data_age14),
   .lst_inv_addr_cmd14(lst_inv_addr_cmd14),  
   .lst_inv_port_cmd14(lst_inv_port_cmd14),  
   .age_confirmed14(age_confirmed14),     
   .age_ok14(age_ok14),
   .inval_in_prog14(inval_in_prog14),            
   .age_check_active14(age_check_active14)
);   


alut_mem14 i_alut_mem14
(   
   // Inputs14
   .pclk14(pclk14),
   .mem_addr_add14(mem_addr_add14),
   .mem_write_add14(mem_write_add14),
   .mem_write_data_add14(mem_write_data_add14),
   .mem_addr_age14(mem_addr_age14),
   .mem_write_age14(mem_write_age14),
   .mem_write_data_age14(mem_write_data_age14),

   .mem_read_data_add14(mem_read_data_add14),  
   .mem_read_data_age14(mem_read_data_age14)
);   



`ifdef ABV_ON14
// psl14 default clock14 = (posedge pclk14);

// ASSUMPTIONS14

// ASSERTION14 CHECKS14
// the invalidate14 aged14 in progress14 flag14 and the active flag14 
// should never both be set.
// psl14 assert_inval_in_prog_active14 : assert never (inval_in_prog14 & active);

// it should never be possible14 for the destination14 port to indicate14 the MAC14
// switch14 address and one of the other 4 Ethernets14
// psl14 assert_valid_dest_port14 : assert never (d_port14[4] & |{d_port14[3:0]});

// COVER14 SANITY14 CHECKS14
// check all values of destination14 port can be returned.
// psl14 cover_d_port_014 : cover { d_port14 == 5'b0_0001 };
// psl14 cover_d_port_114 : cover { d_port14 == 5'b0_0010 };
// psl14 cover_d_port_214 : cover { d_port14 == 5'b0_0100 };
// psl14 cover_d_port_314 : cover { d_port14 == 5'b0_1000 };
// psl14 cover_d_port_414 : cover { d_port14 == 5'b1_0000 };
// psl14 cover_d_port_all14 : cover { d_port14 == 5'b0_1111 };

`endif


endmodule
