//File15 name   : alut15.v
//Title15       : ALUT15 top level
//Created15     : 1999
//Description15 : 
//Notes15       : 
//----------------------------------------------------------------------
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------
module alut15
(   
   // Inputs15
   pclk15,
   n_p_reset15,
   psel15,            
   penable15,       
   pwrite15,         
   paddr15,           
   pwdata15,          

   // Outputs15
   prdata15  
);

   parameter   DW15 = 83;          // width of data busses15
   parameter   DD15 = 256;         // depth of RAM15


   // APB15 Inputs15
   input             pclk15;               // APB15 clock15                          
   input             n_p_reset15;          // Reset15                              
   input             psel15;               // Module15 select15 signal15               
   input             penable15;            // Enable15 signal15                      
   input             pwrite15;             // Write when HIGH15 and read when LOW15  
   input [6:0]       paddr15;              // Address bus for read write         
   input [31:0]      pwdata15;             // APB15 write bus                      

   output [31:0]     prdata15;             // APB15 read bus                       

   wire              pclk15;               // APB15 clock15                           
   wire [7:0]        mem_addr_add15;       // hash15 address for R/W15 to memory     
   wire              mem_write_add15;      // R/W15 flag15 (write = high15)            
   wire [DW15-1:0]     mem_write_data_add15; // write data for memory             
   wire [7:0]        mem_addr_age15;       // hash15 address for R/W15 to memory     
   wire              mem_write_age15;      // R/W15 flag15 (write = high15)            
   wire [DW15-1:0]     mem_write_data_age15; // write data for memory             
   wire [DW15-1:0]     mem_read_data_add15;  // read data from mem                 
   wire [DW15-1:0]     mem_read_data_age15;  // read data from mem  
   wire [31:0]       curr_time15;          // current time
   wire              active;             // status[0] adress15 checker active
   wire              inval_in_prog15;      // status[1] 
   wire              reused15;             // status[2] ALUT15 location15 overwritten15
   wire [4:0]        d_port15;             // calculated15 destination15 port for tx15
   wire [47:0]       lst_inv_addr_nrm15;   // last invalidated15 addr normal15 op
   wire [1:0]        lst_inv_port_nrm15;   // last invalidated15 port normal15 op
   wire [47:0]       lst_inv_addr_cmd15;   // last invalidated15 addr via cmd15
   wire [1:0]        lst_inv_port_cmd15;   // last invalidated15 port via cmd15
   wire [47:0]       mac_addr15;           // address of the switch15
   wire [47:0]       d_addr15;             // address of frame15 to be checked15
   wire [47:0]       s_addr15;             // address of frame15 to be stored15
   wire [1:0]        s_port15;             // source15 port of current frame15
   wire [31:0]       best_bfr_age15;       // best15 before age15
   wire [7:0]        div_clk15;            // programmed15 clock15 divider15 value
   wire [1:0]        command;            // command bus
   wire [31:0]       prdata15;             // APB15 read bus
   wire              age_confirmed15;      // valid flag15 from age15 checker        
   wire              age_ok15;             // result from age15 checker 
   wire              clear_reused15;       // read/clear flag15 for reused15 signal15           
   wire              check_age15;          // request flag15 for age15 check
   wire [31:0]       last_accessed15;      // time field sent15 for age15 check




alut_reg_bank15 i_alut_reg_bank15
(   
   // Inputs15
   .pclk15(pclk15),
   .n_p_reset15(n_p_reset15),
   .psel15(psel15),            
   .penable15(penable15),       
   .pwrite15(pwrite15),         
   .paddr15(paddr15),           
   .pwdata15(pwdata15),          
   .curr_time15(curr_time15),
   .add_check_active15(add_check_active15),
   .age_check_active15(age_check_active15),
   .inval_in_prog15(inval_in_prog15),
   .reused15(reused15),
   .d_port15(d_port15),
   .lst_inv_addr_nrm15(lst_inv_addr_nrm15),
   .lst_inv_port_nrm15(lst_inv_port_nrm15),
   .lst_inv_addr_cmd15(lst_inv_addr_cmd15),
   .lst_inv_port_cmd15(lst_inv_port_cmd15),

   // Outputs15
   .mac_addr15(mac_addr15),    
   .d_addr15(d_addr15),   
   .s_addr15(s_addr15),    
   .s_port15(s_port15),    
   .best_bfr_age15(best_bfr_age15),
   .div_clk15(div_clk15),     
   .command(command), 
   .prdata15(prdata15),  
   .clear_reused15(clear_reused15)           
);


alut_addr_checker15 i_alut_addr_checker15
(   
   // Inputs15
   .pclk15(pclk15),
   .n_p_reset15(n_p_reset15),
   .command(command),
   .mac_addr15(mac_addr15),
   .d_addr15(d_addr15),
   .s_addr15(s_addr15),
   .s_port15(s_port15),
   .curr_time15(curr_time15),
   .mem_read_data_add15(mem_read_data_add15),
   .age_confirmed15(age_confirmed15),
   .age_ok15(age_ok15),
   .clear_reused15(clear_reused15),

   //outputs15
   .d_port15(d_port15),
   .add_check_active15(add_check_active15),
   .mem_addr_add15(mem_addr_add15),
   .mem_write_add15(mem_write_add15),
   .mem_write_data_add15(mem_write_data_add15),
   .lst_inv_addr_nrm15(lst_inv_addr_nrm15),
   .lst_inv_port_nrm15(lst_inv_port_nrm15),
   .check_age15(check_age15),
   .last_accessed15(last_accessed15),
   .reused15(reused15)
);


alut_age_checker15 i_alut_age_checker15
(   
   // Inputs15
   .pclk15(pclk15),
   .n_p_reset15(n_p_reset15),
   .command(command),          
   .div_clk15(div_clk15),          
   .mem_read_data_age15(mem_read_data_age15),
   .check_age15(check_age15),        
   .last_accessed15(last_accessed15), 
   .best_bfr_age15(best_bfr_age15),   
   .add_check_active15(add_check_active15),

   // outputs15
   .curr_time15(curr_time15),         
   .mem_addr_age15(mem_addr_age15),      
   .mem_write_age15(mem_write_age15),     
   .mem_write_data_age15(mem_write_data_age15),
   .lst_inv_addr_cmd15(lst_inv_addr_cmd15),  
   .lst_inv_port_cmd15(lst_inv_port_cmd15),  
   .age_confirmed15(age_confirmed15),     
   .age_ok15(age_ok15),
   .inval_in_prog15(inval_in_prog15),            
   .age_check_active15(age_check_active15)
);   


alut_mem15 i_alut_mem15
(   
   // Inputs15
   .pclk15(pclk15),
   .mem_addr_add15(mem_addr_add15),
   .mem_write_add15(mem_write_add15),
   .mem_write_data_add15(mem_write_data_add15),
   .mem_addr_age15(mem_addr_age15),
   .mem_write_age15(mem_write_age15),
   .mem_write_data_age15(mem_write_data_age15),

   .mem_read_data_add15(mem_read_data_add15),  
   .mem_read_data_age15(mem_read_data_age15)
);   



`ifdef ABV_ON15
// psl15 default clock15 = (posedge pclk15);

// ASSUMPTIONS15

// ASSERTION15 CHECKS15
// the invalidate15 aged15 in progress15 flag15 and the active flag15 
// should never both be set.
// psl15 assert_inval_in_prog_active15 : assert never (inval_in_prog15 & active);

// it should never be possible15 for the destination15 port to indicate15 the MAC15
// switch15 address and one of the other 4 Ethernets15
// psl15 assert_valid_dest_port15 : assert never (d_port15[4] & |{d_port15[3:0]});

// COVER15 SANITY15 CHECKS15
// check all values of destination15 port can be returned.
// psl15 cover_d_port_015 : cover { d_port15 == 5'b0_0001 };
// psl15 cover_d_port_115 : cover { d_port15 == 5'b0_0010 };
// psl15 cover_d_port_215 : cover { d_port15 == 5'b0_0100 };
// psl15 cover_d_port_315 : cover { d_port15 == 5'b0_1000 };
// psl15 cover_d_port_415 : cover { d_port15 == 5'b1_0000 };
// psl15 cover_d_port_all15 : cover { d_port15 == 5'b0_1111 };

`endif


endmodule
