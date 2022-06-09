//File16 name   : alut16.v
//Title16       : ALUT16 top level
//Created16     : 1999
//Description16 : 
//Notes16       : 
//----------------------------------------------------------------------
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------
module alut16
(   
   // Inputs16
   pclk16,
   n_p_reset16,
   psel16,            
   penable16,       
   pwrite16,         
   paddr16,           
   pwdata16,          

   // Outputs16
   prdata16  
);

   parameter   DW16 = 83;          // width of data busses16
   parameter   DD16 = 256;         // depth of RAM16


   // APB16 Inputs16
   input             pclk16;               // APB16 clock16                          
   input             n_p_reset16;          // Reset16                              
   input             psel16;               // Module16 select16 signal16               
   input             penable16;            // Enable16 signal16                      
   input             pwrite16;             // Write when HIGH16 and read when LOW16  
   input [6:0]       paddr16;              // Address bus for read write         
   input [31:0]      pwdata16;             // APB16 write bus                      

   output [31:0]     prdata16;             // APB16 read bus                       

   wire              pclk16;               // APB16 clock16                           
   wire [7:0]        mem_addr_add16;       // hash16 address for R/W16 to memory     
   wire              mem_write_add16;      // R/W16 flag16 (write = high16)            
   wire [DW16-1:0]     mem_write_data_add16; // write data for memory             
   wire [7:0]        mem_addr_age16;       // hash16 address for R/W16 to memory     
   wire              mem_write_age16;      // R/W16 flag16 (write = high16)            
   wire [DW16-1:0]     mem_write_data_age16; // write data for memory             
   wire [DW16-1:0]     mem_read_data_add16;  // read data from mem                 
   wire [DW16-1:0]     mem_read_data_age16;  // read data from mem  
   wire [31:0]       curr_time16;          // current time
   wire              active;             // status[0] adress16 checker active
   wire              inval_in_prog16;      // status[1] 
   wire              reused16;             // status[2] ALUT16 location16 overwritten16
   wire [4:0]        d_port16;             // calculated16 destination16 port for tx16
   wire [47:0]       lst_inv_addr_nrm16;   // last invalidated16 addr normal16 op
   wire [1:0]        lst_inv_port_nrm16;   // last invalidated16 port normal16 op
   wire [47:0]       lst_inv_addr_cmd16;   // last invalidated16 addr via cmd16
   wire [1:0]        lst_inv_port_cmd16;   // last invalidated16 port via cmd16
   wire [47:0]       mac_addr16;           // address of the switch16
   wire [47:0]       d_addr16;             // address of frame16 to be checked16
   wire [47:0]       s_addr16;             // address of frame16 to be stored16
   wire [1:0]        s_port16;             // source16 port of current frame16
   wire [31:0]       best_bfr_age16;       // best16 before age16
   wire [7:0]        div_clk16;            // programmed16 clock16 divider16 value
   wire [1:0]        command;            // command bus
   wire [31:0]       prdata16;             // APB16 read bus
   wire              age_confirmed16;      // valid flag16 from age16 checker        
   wire              age_ok16;             // result from age16 checker 
   wire              clear_reused16;       // read/clear flag16 for reused16 signal16           
   wire              check_age16;          // request flag16 for age16 check
   wire [31:0]       last_accessed16;      // time field sent16 for age16 check




alut_reg_bank16 i_alut_reg_bank16
(   
   // Inputs16
   .pclk16(pclk16),
   .n_p_reset16(n_p_reset16),
   .psel16(psel16),            
   .penable16(penable16),       
   .pwrite16(pwrite16),         
   .paddr16(paddr16),           
   .pwdata16(pwdata16),          
   .curr_time16(curr_time16),
   .add_check_active16(add_check_active16),
   .age_check_active16(age_check_active16),
   .inval_in_prog16(inval_in_prog16),
   .reused16(reused16),
   .d_port16(d_port16),
   .lst_inv_addr_nrm16(lst_inv_addr_nrm16),
   .lst_inv_port_nrm16(lst_inv_port_nrm16),
   .lst_inv_addr_cmd16(lst_inv_addr_cmd16),
   .lst_inv_port_cmd16(lst_inv_port_cmd16),

   // Outputs16
   .mac_addr16(mac_addr16),    
   .d_addr16(d_addr16),   
   .s_addr16(s_addr16),    
   .s_port16(s_port16),    
   .best_bfr_age16(best_bfr_age16),
   .div_clk16(div_clk16),     
   .command(command), 
   .prdata16(prdata16),  
   .clear_reused16(clear_reused16)           
);


alut_addr_checker16 i_alut_addr_checker16
(   
   // Inputs16
   .pclk16(pclk16),
   .n_p_reset16(n_p_reset16),
   .command(command),
   .mac_addr16(mac_addr16),
   .d_addr16(d_addr16),
   .s_addr16(s_addr16),
   .s_port16(s_port16),
   .curr_time16(curr_time16),
   .mem_read_data_add16(mem_read_data_add16),
   .age_confirmed16(age_confirmed16),
   .age_ok16(age_ok16),
   .clear_reused16(clear_reused16),

   //outputs16
   .d_port16(d_port16),
   .add_check_active16(add_check_active16),
   .mem_addr_add16(mem_addr_add16),
   .mem_write_add16(mem_write_add16),
   .mem_write_data_add16(mem_write_data_add16),
   .lst_inv_addr_nrm16(lst_inv_addr_nrm16),
   .lst_inv_port_nrm16(lst_inv_port_nrm16),
   .check_age16(check_age16),
   .last_accessed16(last_accessed16),
   .reused16(reused16)
);


alut_age_checker16 i_alut_age_checker16
(   
   // Inputs16
   .pclk16(pclk16),
   .n_p_reset16(n_p_reset16),
   .command(command),          
   .div_clk16(div_clk16),          
   .mem_read_data_age16(mem_read_data_age16),
   .check_age16(check_age16),        
   .last_accessed16(last_accessed16), 
   .best_bfr_age16(best_bfr_age16),   
   .add_check_active16(add_check_active16),

   // outputs16
   .curr_time16(curr_time16),         
   .mem_addr_age16(mem_addr_age16),      
   .mem_write_age16(mem_write_age16),     
   .mem_write_data_age16(mem_write_data_age16),
   .lst_inv_addr_cmd16(lst_inv_addr_cmd16),  
   .lst_inv_port_cmd16(lst_inv_port_cmd16),  
   .age_confirmed16(age_confirmed16),     
   .age_ok16(age_ok16),
   .inval_in_prog16(inval_in_prog16),            
   .age_check_active16(age_check_active16)
);   


alut_mem16 i_alut_mem16
(   
   // Inputs16
   .pclk16(pclk16),
   .mem_addr_add16(mem_addr_add16),
   .mem_write_add16(mem_write_add16),
   .mem_write_data_add16(mem_write_data_add16),
   .mem_addr_age16(mem_addr_age16),
   .mem_write_age16(mem_write_age16),
   .mem_write_data_age16(mem_write_data_age16),

   .mem_read_data_add16(mem_read_data_add16),  
   .mem_read_data_age16(mem_read_data_age16)
);   



`ifdef ABV_ON16
// psl16 default clock16 = (posedge pclk16);

// ASSUMPTIONS16

// ASSERTION16 CHECKS16
// the invalidate16 aged16 in progress16 flag16 and the active flag16 
// should never both be set.
// psl16 assert_inval_in_prog_active16 : assert never (inval_in_prog16 & active);

// it should never be possible16 for the destination16 port to indicate16 the MAC16
// switch16 address and one of the other 4 Ethernets16
// psl16 assert_valid_dest_port16 : assert never (d_port16[4] & |{d_port16[3:0]});

// COVER16 SANITY16 CHECKS16
// check all values of destination16 port can be returned.
// psl16 cover_d_port_016 : cover { d_port16 == 5'b0_0001 };
// psl16 cover_d_port_116 : cover { d_port16 == 5'b0_0010 };
// psl16 cover_d_port_216 : cover { d_port16 == 5'b0_0100 };
// psl16 cover_d_port_316 : cover { d_port16 == 5'b0_1000 };
// psl16 cover_d_port_416 : cover { d_port16 == 5'b1_0000 };
// psl16 cover_d_port_all16 : cover { d_port16 == 5'b0_1111 };

`endif


endmodule
