//File8 name   : alut8.v
//Title8       : ALUT8 top level
//Created8     : 1999
//Description8 : 
//Notes8       : 
//----------------------------------------------------------------------
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------
module alut8
(   
   // Inputs8
   pclk8,
   n_p_reset8,
   psel8,            
   penable8,       
   pwrite8,         
   paddr8,           
   pwdata8,          

   // Outputs8
   prdata8  
);

   parameter   DW8 = 83;          // width of data busses8
   parameter   DD8 = 256;         // depth of RAM8


   // APB8 Inputs8
   input             pclk8;               // APB8 clock8                          
   input             n_p_reset8;          // Reset8                              
   input             psel8;               // Module8 select8 signal8               
   input             penable8;            // Enable8 signal8                      
   input             pwrite8;             // Write when HIGH8 and read when LOW8  
   input [6:0]       paddr8;              // Address bus for read write         
   input [31:0]      pwdata8;             // APB8 write bus                      

   output [31:0]     prdata8;             // APB8 read bus                       

   wire              pclk8;               // APB8 clock8                           
   wire [7:0]        mem_addr_add8;       // hash8 address for R/W8 to memory     
   wire              mem_write_add8;      // R/W8 flag8 (write = high8)            
   wire [DW8-1:0]     mem_write_data_add8; // write data for memory             
   wire [7:0]        mem_addr_age8;       // hash8 address for R/W8 to memory     
   wire              mem_write_age8;      // R/W8 flag8 (write = high8)            
   wire [DW8-1:0]     mem_write_data_age8; // write data for memory             
   wire [DW8-1:0]     mem_read_data_add8;  // read data from mem                 
   wire [DW8-1:0]     mem_read_data_age8;  // read data from mem  
   wire [31:0]       curr_time8;          // current time
   wire              active;             // status[0] adress8 checker active
   wire              inval_in_prog8;      // status[1] 
   wire              reused8;             // status[2] ALUT8 location8 overwritten8
   wire [4:0]        d_port8;             // calculated8 destination8 port for tx8
   wire [47:0]       lst_inv_addr_nrm8;   // last invalidated8 addr normal8 op
   wire [1:0]        lst_inv_port_nrm8;   // last invalidated8 port normal8 op
   wire [47:0]       lst_inv_addr_cmd8;   // last invalidated8 addr via cmd8
   wire [1:0]        lst_inv_port_cmd8;   // last invalidated8 port via cmd8
   wire [47:0]       mac_addr8;           // address of the switch8
   wire [47:0]       d_addr8;             // address of frame8 to be checked8
   wire [47:0]       s_addr8;             // address of frame8 to be stored8
   wire [1:0]        s_port8;             // source8 port of current frame8
   wire [31:0]       best_bfr_age8;       // best8 before age8
   wire [7:0]        div_clk8;            // programmed8 clock8 divider8 value
   wire [1:0]        command;            // command bus
   wire [31:0]       prdata8;             // APB8 read bus
   wire              age_confirmed8;      // valid flag8 from age8 checker        
   wire              age_ok8;             // result from age8 checker 
   wire              clear_reused8;       // read/clear flag8 for reused8 signal8           
   wire              check_age8;          // request flag8 for age8 check
   wire [31:0]       last_accessed8;      // time field sent8 for age8 check




alut_reg_bank8 i_alut_reg_bank8
(   
   // Inputs8
   .pclk8(pclk8),
   .n_p_reset8(n_p_reset8),
   .psel8(psel8),            
   .penable8(penable8),       
   .pwrite8(pwrite8),         
   .paddr8(paddr8),           
   .pwdata8(pwdata8),          
   .curr_time8(curr_time8),
   .add_check_active8(add_check_active8),
   .age_check_active8(age_check_active8),
   .inval_in_prog8(inval_in_prog8),
   .reused8(reused8),
   .d_port8(d_port8),
   .lst_inv_addr_nrm8(lst_inv_addr_nrm8),
   .lst_inv_port_nrm8(lst_inv_port_nrm8),
   .lst_inv_addr_cmd8(lst_inv_addr_cmd8),
   .lst_inv_port_cmd8(lst_inv_port_cmd8),

   // Outputs8
   .mac_addr8(mac_addr8),    
   .d_addr8(d_addr8),   
   .s_addr8(s_addr8),    
   .s_port8(s_port8),    
   .best_bfr_age8(best_bfr_age8),
   .div_clk8(div_clk8),     
   .command(command), 
   .prdata8(prdata8),  
   .clear_reused8(clear_reused8)           
);


alut_addr_checker8 i_alut_addr_checker8
(   
   // Inputs8
   .pclk8(pclk8),
   .n_p_reset8(n_p_reset8),
   .command(command),
   .mac_addr8(mac_addr8),
   .d_addr8(d_addr8),
   .s_addr8(s_addr8),
   .s_port8(s_port8),
   .curr_time8(curr_time8),
   .mem_read_data_add8(mem_read_data_add8),
   .age_confirmed8(age_confirmed8),
   .age_ok8(age_ok8),
   .clear_reused8(clear_reused8),

   //outputs8
   .d_port8(d_port8),
   .add_check_active8(add_check_active8),
   .mem_addr_add8(mem_addr_add8),
   .mem_write_add8(mem_write_add8),
   .mem_write_data_add8(mem_write_data_add8),
   .lst_inv_addr_nrm8(lst_inv_addr_nrm8),
   .lst_inv_port_nrm8(lst_inv_port_nrm8),
   .check_age8(check_age8),
   .last_accessed8(last_accessed8),
   .reused8(reused8)
);


alut_age_checker8 i_alut_age_checker8
(   
   // Inputs8
   .pclk8(pclk8),
   .n_p_reset8(n_p_reset8),
   .command(command),          
   .div_clk8(div_clk8),          
   .mem_read_data_age8(mem_read_data_age8),
   .check_age8(check_age8),        
   .last_accessed8(last_accessed8), 
   .best_bfr_age8(best_bfr_age8),   
   .add_check_active8(add_check_active8),

   // outputs8
   .curr_time8(curr_time8),         
   .mem_addr_age8(mem_addr_age8),      
   .mem_write_age8(mem_write_age8),     
   .mem_write_data_age8(mem_write_data_age8),
   .lst_inv_addr_cmd8(lst_inv_addr_cmd8),  
   .lst_inv_port_cmd8(lst_inv_port_cmd8),  
   .age_confirmed8(age_confirmed8),     
   .age_ok8(age_ok8),
   .inval_in_prog8(inval_in_prog8),            
   .age_check_active8(age_check_active8)
);   


alut_mem8 i_alut_mem8
(   
   // Inputs8
   .pclk8(pclk8),
   .mem_addr_add8(mem_addr_add8),
   .mem_write_add8(mem_write_add8),
   .mem_write_data_add8(mem_write_data_add8),
   .mem_addr_age8(mem_addr_age8),
   .mem_write_age8(mem_write_age8),
   .mem_write_data_age8(mem_write_data_age8),

   .mem_read_data_add8(mem_read_data_add8),  
   .mem_read_data_age8(mem_read_data_age8)
);   



`ifdef ABV_ON8
// psl8 default clock8 = (posedge pclk8);

// ASSUMPTIONS8

// ASSERTION8 CHECKS8
// the invalidate8 aged8 in progress8 flag8 and the active flag8 
// should never both be set.
// psl8 assert_inval_in_prog_active8 : assert never (inval_in_prog8 & active);

// it should never be possible8 for the destination8 port to indicate8 the MAC8
// switch8 address and one of the other 4 Ethernets8
// psl8 assert_valid_dest_port8 : assert never (d_port8[4] & |{d_port8[3:0]});

// COVER8 SANITY8 CHECKS8
// check all values of destination8 port can be returned.
// psl8 cover_d_port_08 : cover { d_port8 == 5'b0_0001 };
// psl8 cover_d_port_18 : cover { d_port8 == 5'b0_0010 };
// psl8 cover_d_port_28 : cover { d_port8 == 5'b0_0100 };
// psl8 cover_d_port_38 : cover { d_port8 == 5'b0_1000 };
// psl8 cover_d_port_48 : cover { d_port8 == 5'b1_0000 };
// psl8 cover_d_port_all8 : cover { d_port8 == 5'b0_1111 };

`endif


endmodule
