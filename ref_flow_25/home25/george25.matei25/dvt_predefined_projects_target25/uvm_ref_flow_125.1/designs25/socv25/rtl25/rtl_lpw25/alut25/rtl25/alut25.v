//File25 name   : alut25.v
//Title25       : ALUT25 top level
//Created25     : 1999
//Description25 : 
//Notes25       : 
//----------------------------------------------------------------------
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------
module alut25
(   
   // Inputs25
   pclk25,
   n_p_reset25,
   psel25,            
   penable25,       
   pwrite25,         
   paddr25,           
   pwdata25,          

   // Outputs25
   prdata25  
);

   parameter   DW25 = 83;          // width of data busses25
   parameter   DD25 = 256;         // depth of RAM25


   // APB25 Inputs25
   input             pclk25;               // APB25 clock25                          
   input             n_p_reset25;          // Reset25                              
   input             psel25;               // Module25 select25 signal25               
   input             penable25;            // Enable25 signal25                      
   input             pwrite25;             // Write when HIGH25 and read when LOW25  
   input [6:0]       paddr25;              // Address bus for read write         
   input [31:0]      pwdata25;             // APB25 write bus                      

   output [31:0]     prdata25;             // APB25 read bus                       

   wire              pclk25;               // APB25 clock25                           
   wire [7:0]        mem_addr_add25;       // hash25 address for R/W25 to memory     
   wire              mem_write_add25;      // R/W25 flag25 (write = high25)            
   wire [DW25-1:0]     mem_write_data_add25; // write data for memory             
   wire [7:0]        mem_addr_age25;       // hash25 address for R/W25 to memory     
   wire              mem_write_age25;      // R/W25 flag25 (write = high25)            
   wire [DW25-1:0]     mem_write_data_age25; // write data for memory             
   wire [DW25-1:0]     mem_read_data_add25;  // read data from mem                 
   wire [DW25-1:0]     mem_read_data_age25;  // read data from mem  
   wire [31:0]       curr_time25;          // current time
   wire              active;             // status[0] adress25 checker active
   wire              inval_in_prog25;      // status[1] 
   wire              reused25;             // status[2] ALUT25 location25 overwritten25
   wire [4:0]        d_port25;             // calculated25 destination25 port for tx25
   wire [47:0]       lst_inv_addr_nrm25;   // last invalidated25 addr normal25 op
   wire [1:0]        lst_inv_port_nrm25;   // last invalidated25 port normal25 op
   wire [47:0]       lst_inv_addr_cmd25;   // last invalidated25 addr via cmd25
   wire [1:0]        lst_inv_port_cmd25;   // last invalidated25 port via cmd25
   wire [47:0]       mac_addr25;           // address of the switch25
   wire [47:0]       d_addr25;             // address of frame25 to be checked25
   wire [47:0]       s_addr25;             // address of frame25 to be stored25
   wire [1:0]        s_port25;             // source25 port of current frame25
   wire [31:0]       best_bfr_age25;       // best25 before age25
   wire [7:0]        div_clk25;            // programmed25 clock25 divider25 value
   wire [1:0]        command;            // command bus
   wire [31:0]       prdata25;             // APB25 read bus
   wire              age_confirmed25;      // valid flag25 from age25 checker        
   wire              age_ok25;             // result from age25 checker 
   wire              clear_reused25;       // read/clear flag25 for reused25 signal25           
   wire              check_age25;          // request flag25 for age25 check
   wire [31:0]       last_accessed25;      // time field sent25 for age25 check




alut_reg_bank25 i_alut_reg_bank25
(   
   // Inputs25
   .pclk25(pclk25),
   .n_p_reset25(n_p_reset25),
   .psel25(psel25),            
   .penable25(penable25),       
   .pwrite25(pwrite25),         
   .paddr25(paddr25),           
   .pwdata25(pwdata25),          
   .curr_time25(curr_time25),
   .add_check_active25(add_check_active25),
   .age_check_active25(age_check_active25),
   .inval_in_prog25(inval_in_prog25),
   .reused25(reused25),
   .d_port25(d_port25),
   .lst_inv_addr_nrm25(lst_inv_addr_nrm25),
   .lst_inv_port_nrm25(lst_inv_port_nrm25),
   .lst_inv_addr_cmd25(lst_inv_addr_cmd25),
   .lst_inv_port_cmd25(lst_inv_port_cmd25),

   // Outputs25
   .mac_addr25(mac_addr25),    
   .d_addr25(d_addr25),   
   .s_addr25(s_addr25),    
   .s_port25(s_port25),    
   .best_bfr_age25(best_bfr_age25),
   .div_clk25(div_clk25),     
   .command(command), 
   .prdata25(prdata25),  
   .clear_reused25(clear_reused25)           
);


alut_addr_checker25 i_alut_addr_checker25
(   
   // Inputs25
   .pclk25(pclk25),
   .n_p_reset25(n_p_reset25),
   .command(command),
   .mac_addr25(mac_addr25),
   .d_addr25(d_addr25),
   .s_addr25(s_addr25),
   .s_port25(s_port25),
   .curr_time25(curr_time25),
   .mem_read_data_add25(mem_read_data_add25),
   .age_confirmed25(age_confirmed25),
   .age_ok25(age_ok25),
   .clear_reused25(clear_reused25),

   //outputs25
   .d_port25(d_port25),
   .add_check_active25(add_check_active25),
   .mem_addr_add25(mem_addr_add25),
   .mem_write_add25(mem_write_add25),
   .mem_write_data_add25(mem_write_data_add25),
   .lst_inv_addr_nrm25(lst_inv_addr_nrm25),
   .lst_inv_port_nrm25(lst_inv_port_nrm25),
   .check_age25(check_age25),
   .last_accessed25(last_accessed25),
   .reused25(reused25)
);


alut_age_checker25 i_alut_age_checker25
(   
   // Inputs25
   .pclk25(pclk25),
   .n_p_reset25(n_p_reset25),
   .command(command),          
   .div_clk25(div_clk25),          
   .mem_read_data_age25(mem_read_data_age25),
   .check_age25(check_age25),        
   .last_accessed25(last_accessed25), 
   .best_bfr_age25(best_bfr_age25),   
   .add_check_active25(add_check_active25),

   // outputs25
   .curr_time25(curr_time25),         
   .mem_addr_age25(mem_addr_age25),      
   .mem_write_age25(mem_write_age25),     
   .mem_write_data_age25(mem_write_data_age25),
   .lst_inv_addr_cmd25(lst_inv_addr_cmd25),  
   .lst_inv_port_cmd25(lst_inv_port_cmd25),  
   .age_confirmed25(age_confirmed25),     
   .age_ok25(age_ok25),
   .inval_in_prog25(inval_in_prog25),            
   .age_check_active25(age_check_active25)
);   


alut_mem25 i_alut_mem25
(   
   // Inputs25
   .pclk25(pclk25),
   .mem_addr_add25(mem_addr_add25),
   .mem_write_add25(mem_write_add25),
   .mem_write_data_add25(mem_write_data_add25),
   .mem_addr_age25(mem_addr_age25),
   .mem_write_age25(mem_write_age25),
   .mem_write_data_age25(mem_write_data_age25),

   .mem_read_data_add25(mem_read_data_add25),  
   .mem_read_data_age25(mem_read_data_age25)
);   



`ifdef ABV_ON25
// psl25 default clock25 = (posedge pclk25);

// ASSUMPTIONS25

// ASSERTION25 CHECKS25
// the invalidate25 aged25 in progress25 flag25 and the active flag25 
// should never both be set.
// psl25 assert_inval_in_prog_active25 : assert never (inval_in_prog25 & active);

// it should never be possible25 for the destination25 port to indicate25 the MAC25
// switch25 address and one of the other 4 Ethernets25
// psl25 assert_valid_dest_port25 : assert never (d_port25[4] & |{d_port25[3:0]});

// COVER25 SANITY25 CHECKS25
// check all values of destination25 port can be returned.
// psl25 cover_d_port_025 : cover { d_port25 == 5'b0_0001 };
// psl25 cover_d_port_125 : cover { d_port25 == 5'b0_0010 };
// psl25 cover_d_port_225 : cover { d_port25 == 5'b0_0100 };
// psl25 cover_d_port_325 : cover { d_port25 == 5'b0_1000 };
// psl25 cover_d_port_425 : cover { d_port25 == 5'b1_0000 };
// psl25 cover_d_port_all25 : cover { d_port25 == 5'b0_1111 };

`endif


endmodule
