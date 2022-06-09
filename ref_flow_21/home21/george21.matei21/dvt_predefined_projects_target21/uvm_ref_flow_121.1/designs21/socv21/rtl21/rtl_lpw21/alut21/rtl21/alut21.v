//File21 name   : alut21.v
//Title21       : ALUT21 top level
//Created21     : 1999
//Description21 : 
//Notes21       : 
//----------------------------------------------------------------------
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------
module alut21
(   
   // Inputs21
   pclk21,
   n_p_reset21,
   psel21,            
   penable21,       
   pwrite21,         
   paddr21,           
   pwdata21,          

   // Outputs21
   prdata21  
);

   parameter   DW21 = 83;          // width of data busses21
   parameter   DD21 = 256;         // depth of RAM21


   // APB21 Inputs21
   input             pclk21;               // APB21 clock21                          
   input             n_p_reset21;          // Reset21                              
   input             psel21;               // Module21 select21 signal21               
   input             penable21;            // Enable21 signal21                      
   input             pwrite21;             // Write when HIGH21 and read when LOW21  
   input [6:0]       paddr21;              // Address bus for read write         
   input [31:0]      pwdata21;             // APB21 write bus                      

   output [31:0]     prdata21;             // APB21 read bus                       

   wire              pclk21;               // APB21 clock21                           
   wire [7:0]        mem_addr_add21;       // hash21 address for R/W21 to memory     
   wire              mem_write_add21;      // R/W21 flag21 (write = high21)            
   wire [DW21-1:0]     mem_write_data_add21; // write data for memory             
   wire [7:0]        mem_addr_age21;       // hash21 address for R/W21 to memory     
   wire              mem_write_age21;      // R/W21 flag21 (write = high21)            
   wire [DW21-1:0]     mem_write_data_age21; // write data for memory             
   wire [DW21-1:0]     mem_read_data_add21;  // read data from mem                 
   wire [DW21-1:0]     mem_read_data_age21;  // read data from mem  
   wire [31:0]       curr_time21;          // current time
   wire              active;             // status[0] adress21 checker active
   wire              inval_in_prog21;      // status[1] 
   wire              reused21;             // status[2] ALUT21 location21 overwritten21
   wire [4:0]        d_port21;             // calculated21 destination21 port for tx21
   wire [47:0]       lst_inv_addr_nrm21;   // last invalidated21 addr normal21 op
   wire [1:0]        lst_inv_port_nrm21;   // last invalidated21 port normal21 op
   wire [47:0]       lst_inv_addr_cmd21;   // last invalidated21 addr via cmd21
   wire [1:0]        lst_inv_port_cmd21;   // last invalidated21 port via cmd21
   wire [47:0]       mac_addr21;           // address of the switch21
   wire [47:0]       d_addr21;             // address of frame21 to be checked21
   wire [47:0]       s_addr21;             // address of frame21 to be stored21
   wire [1:0]        s_port21;             // source21 port of current frame21
   wire [31:0]       best_bfr_age21;       // best21 before age21
   wire [7:0]        div_clk21;            // programmed21 clock21 divider21 value
   wire [1:0]        command;            // command bus
   wire [31:0]       prdata21;             // APB21 read bus
   wire              age_confirmed21;      // valid flag21 from age21 checker        
   wire              age_ok21;             // result from age21 checker 
   wire              clear_reused21;       // read/clear flag21 for reused21 signal21           
   wire              check_age21;          // request flag21 for age21 check
   wire [31:0]       last_accessed21;      // time field sent21 for age21 check




alut_reg_bank21 i_alut_reg_bank21
(   
   // Inputs21
   .pclk21(pclk21),
   .n_p_reset21(n_p_reset21),
   .psel21(psel21),            
   .penable21(penable21),       
   .pwrite21(pwrite21),         
   .paddr21(paddr21),           
   .pwdata21(pwdata21),          
   .curr_time21(curr_time21),
   .add_check_active21(add_check_active21),
   .age_check_active21(age_check_active21),
   .inval_in_prog21(inval_in_prog21),
   .reused21(reused21),
   .d_port21(d_port21),
   .lst_inv_addr_nrm21(lst_inv_addr_nrm21),
   .lst_inv_port_nrm21(lst_inv_port_nrm21),
   .lst_inv_addr_cmd21(lst_inv_addr_cmd21),
   .lst_inv_port_cmd21(lst_inv_port_cmd21),

   // Outputs21
   .mac_addr21(mac_addr21),    
   .d_addr21(d_addr21),   
   .s_addr21(s_addr21),    
   .s_port21(s_port21),    
   .best_bfr_age21(best_bfr_age21),
   .div_clk21(div_clk21),     
   .command(command), 
   .prdata21(prdata21),  
   .clear_reused21(clear_reused21)           
);


alut_addr_checker21 i_alut_addr_checker21
(   
   // Inputs21
   .pclk21(pclk21),
   .n_p_reset21(n_p_reset21),
   .command(command),
   .mac_addr21(mac_addr21),
   .d_addr21(d_addr21),
   .s_addr21(s_addr21),
   .s_port21(s_port21),
   .curr_time21(curr_time21),
   .mem_read_data_add21(mem_read_data_add21),
   .age_confirmed21(age_confirmed21),
   .age_ok21(age_ok21),
   .clear_reused21(clear_reused21),

   //outputs21
   .d_port21(d_port21),
   .add_check_active21(add_check_active21),
   .mem_addr_add21(mem_addr_add21),
   .mem_write_add21(mem_write_add21),
   .mem_write_data_add21(mem_write_data_add21),
   .lst_inv_addr_nrm21(lst_inv_addr_nrm21),
   .lst_inv_port_nrm21(lst_inv_port_nrm21),
   .check_age21(check_age21),
   .last_accessed21(last_accessed21),
   .reused21(reused21)
);


alut_age_checker21 i_alut_age_checker21
(   
   // Inputs21
   .pclk21(pclk21),
   .n_p_reset21(n_p_reset21),
   .command(command),          
   .div_clk21(div_clk21),          
   .mem_read_data_age21(mem_read_data_age21),
   .check_age21(check_age21),        
   .last_accessed21(last_accessed21), 
   .best_bfr_age21(best_bfr_age21),   
   .add_check_active21(add_check_active21),

   // outputs21
   .curr_time21(curr_time21),         
   .mem_addr_age21(mem_addr_age21),      
   .mem_write_age21(mem_write_age21),     
   .mem_write_data_age21(mem_write_data_age21),
   .lst_inv_addr_cmd21(lst_inv_addr_cmd21),  
   .lst_inv_port_cmd21(lst_inv_port_cmd21),  
   .age_confirmed21(age_confirmed21),     
   .age_ok21(age_ok21),
   .inval_in_prog21(inval_in_prog21),            
   .age_check_active21(age_check_active21)
);   


alut_mem21 i_alut_mem21
(   
   // Inputs21
   .pclk21(pclk21),
   .mem_addr_add21(mem_addr_add21),
   .mem_write_add21(mem_write_add21),
   .mem_write_data_add21(mem_write_data_add21),
   .mem_addr_age21(mem_addr_age21),
   .mem_write_age21(mem_write_age21),
   .mem_write_data_age21(mem_write_data_age21),

   .mem_read_data_add21(mem_read_data_add21),  
   .mem_read_data_age21(mem_read_data_age21)
);   



`ifdef ABV_ON21
// psl21 default clock21 = (posedge pclk21);

// ASSUMPTIONS21

// ASSERTION21 CHECKS21
// the invalidate21 aged21 in progress21 flag21 and the active flag21 
// should never both be set.
// psl21 assert_inval_in_prog_active21 : assert never (inval_in_prog21 & active);

// it should never be possible21 for the destination21 port to indicate21 the MAC21
// switch21 address and one of the other 4 Ethernets21
// psl21 assert_valid_dest_port21 : assert never (d_port21[4] & |{d_port21[3:0]});

// COVER21 SANITY21 CHECKS21
// check all values of destination21 port can be returned.
// psl21 cover_d_port_021 : cover { d_port21 == 5'b0_0001 };
// psl21 cover_d_port_121 : cover { d_port21 == 5'b0_0010 };
// psl21 cover_d_port_221 : cover { d_port21 == 5'b0_0100 };
// psl21 cover_d_port_321 : cover { d_port21 == 5'b0_1000 };
// psl21 cover_d_port_421 : cover { d_port21 == 5'b1_0000 };
// psl21 cover_d_port_all21 : cover { d_port21 == 5'b0_1111 };

`endif


endmodule
