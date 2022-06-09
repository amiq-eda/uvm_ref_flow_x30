//File12 name   : alut12.v
//Title12       : ALUT12 top level
//Created12     : 1999
//Description12 : 
//Notes12       : 
//----------------------------------------------------------------------
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------
module alut12
(   
   // Inputs12
   pclk12,
   n_p_reset12,
   psel12,            
   penable12,       
   pwrite12,         
   paddr12,           
   pwdata12,          

   // Outputs12
   prdata12  
);

   parameter   DW12 = 83;          // width of data busses12
   parameter   DD12 = 256;         // depth of RAM12


   // APB12 Inputs12
   input             pclk12;               // APB12 clock12                          
   input             n_p_reset12;          // Reset12                              
   input             psel12;               // Module12 select12 signal12               
   input             penable12;            // Enable12 signal12                      
   input             pwrite12;             // Write when HIGH12 and read when LOW12  
   input [6:0]       paddr12;              // Address bus for read write         
   input [31:0]      pwdata12;             // APB12 write bus                      

   output [31:0]     prdata12;             // APB12 read bus                       

   wire              pclk12;               // APB12 clock12                           
   wire [7:0]        mem_addr_add12;       // hash12 address for R/W12 to memory     
   wire              mem_write_add12;      // R/W12 flag12 (write = high12)            
   wire [DW12-1:0]     mem_write_data_add12; // write data for memory             
   wire [7:0]        mem_addr_age12;       // hash12 address for R/W12 to memory     
   wire              mem_write_age12;      // R/W12 flag12 (write = high12)            
   wire [DW12-1:0]     mem_write_data_age12; // write data for memory             
   wire [DW12-1:0]     mem_read_data_add12;  // read data from mem                 
   wire [DW12-1:0]     mem_read_data_age12;  // read data from mem  
   wire [31:0]       curr_time12;          // current time
   wire              active;             // status[0] adress12 checker active
   wire              inval_in_prog12;      // status[1] 
   wire              reused12;             // status[2] ALUT12 location12 overwritten12
   wire [4:0]        d_port12;             // calculated12 destination12 port for tx12
   wire [47:0]       lst_inv_addr_nrm12;   // last invalidated12 addr normal12 op
   wire [1:0]        lst_inv_port_nrm12;   // last invalidated12 port normal12 op
   wire [47:0]       lst_inv_addr_cmd12;   // last invalidated12 addr via cmd12
   wire [1:0]        lst_inv_port_cmd12;   // last invalidated12 port via cmd12
   wire [47:0]       mac_addr12;           // address of the switch12
   wire [47:0]       d_addr12;             // address of frame12 to be checked12
   wire [47:0]       s_addr12;             // address of frame12 to be stored12
   wire [1:0]        s_port12;             // source12 port of current frame12
   wire [31:0]       best_bfr_age12;       // best12 before age12
   wire [7:0]        div_clk12;            // programmed12 clock12 divider12 value
   wire [1:0]        command;            // command bus
   wire [31:0]       prdata12;             // APB12 read bus
   wire              age_confirmed12;      // valid flag12 from age12 checker        
   wire              age_ok12;             // result from age12 checker 
   wire              clear_reused12;       // read/clear flag12 for reused12 signal12           
   wire              check_age12;          // request flag12 for age12 check
   wire [31:0]       last_accessed12;      // time field sent12 for age12 check




alut_reg_bank12 i_alut_reg_bank12
(   
   // Inputs12
   .pclk12(pclk12),
   .n_p_reset12(n_p_reset12),
   .psel12(psel12),            
   .penable12(penable12),       
   .pwrite12(pwrite12),         
   .paddr12(paddr12),           
   .pwdata12(pwdata12),          
   .curr_time12(curr_time12),
   .add_check_active12(add_check_active12),
   .age_check_active12(age_check_active12),
   .inval_in_prog12(inval_in_prog12),
   .reused12(reused12),
   .d_port12(d_port12),
   .lst_inv_addr_nrm12(lst_inv_addr_nrm12),
   .lst_inv_port_nrm12(lst_inv_port_nrm12),
   .lst_inv_addr_cmd12(lst_inv_addr_cmd12),
   .lst_inv_port_cmd12(lst_inv_port_cmd12),

   // Outputs12
   .mac_addr12(mac_addr12),    
   .d_addr12(d_addr12),   
   .s_addr12(s_addr12),    
   .s_port12(s_port12),    
   .best_bfr_age12(best_bfr_age12),
   .div_clk12(div_clk12),     
   .command(command), 
   .prdata12(prdata12),  
   .clear_reused12(clear_reused12)           
);


alut_addr_checker12 i_alut_addr_checker12
(   
   // Inputs12
   .pclk12(pclk12),
   .n_p_reset12(n_p_reset12),
   .command(command),
   .mac_addr12(mac_addr12),
   .d_addr12(d_addr12),
   .s_addr12(s_addr12),
   .s_port12(s_port12),
   .curr_time12(curr_time12),
   .mem_read_data_add12(mem_read_data_add12),
   .age_confirmed12(age_confirmed12),
   .age_ok12(age_ok12),
   .clear_reused12(clear_reused12),

   //outputs12
   .d_port12(d_port12),
   .add_check_active12(add_check_active12),
   .mem_addr_add12(mem_addr_add12),
   .mem_write_add12(mem_write_add12),
   .mem_write_data_add12(mem_write_data_add12),
   .lst_inv_addr_nrm12(lst_inv_addr_nrm12),
   .lst_inv_port_nrm12(lst_inv_port_nrm12),
   .check_age12(check_age12),
   .last_accessed12(last_accessed12),
   .reused12(reused12)
);


alut_age_checker12 i_alut_age_checker12
(   
   // Inputs12
   .pclk12(pclk12),
   .n_p_reset12(n_p_reset12),
   .command(command),          
   .div_clk12(div_clk12),          
   .mem_read_data_age12(mem_read_data_age12),
   .check_age12(check_age12),        
   .last_accessed12(last_accessed12), 
   .best_bfr_age12(best_bfr_age12),   
   .add_check_active12(add_check_active12),

   // outputs12
   .curr_time12(curr_time12),         
   .mem_addr_age12(mem_addr_age12),      
   .mem_write_age12(mem_write_age12),     
   .mem_write_data_age12(mem_write_data_age12),
   .lst_inv_addr_cmd12(lst_inv_addr_cmd12),  
   .lst_inv_port_cmd12(lst_inv_port_cmd12),  
   .age_confirmed12(age_confirmed12),     
   .age_ok12(age_ok12),
   .inval_in_prog12(inval_in_prog12),            
   .age_check_active12(age_check_active12)
);   


alut_mem12 i_alut_mem12
(   
   // Inputs12
   .pclk12(pclk12),
   .mem_addr_add12(mem_addr_add12),
   .mem_write_add12(mem_write_add12),
   .mem_write_data_add12(mem_write_data_add12),
   .mem_addr_age12(mem_addr_age12),
   .mem_write_age12(mem_write_age12),
   .mem_write_data_age12(mem_write_data_age12),

   .mem_read_data_add12(mem_read_data_add12),  
   .mem_read_data_age12(mem_read_data_age12)
);   



`ifdef ABV_ON12
// psl12 default clock12 = (posedge pclk12);

// ASSUMPTIONS12

// ASSERTION12 CHECKS12
// the invalidate12 aged12 in progress12 flag12 and the active flag12 
// should never both be set.
// psl12 assert_inval_in_prog_active12 : assert never (inval_in_prog12 & active);

// it should never be possible12 for the destination12 port to indicate12 the MAC12
// switch12 address and one of the other 4 Ethernets12
// psl12 assert_valid_dest_port12 : assert never (d_port12[4] & |{d_port12[3:0]});

// COVER12 SANITY12 CHECKS12
// check all values of destination12 port can be returned.
// psl12 cover_d_port_012 : cover { d_port12 == 5'b0_0001 };
// psl12 cover_d_port_112 : cover { d_port12 == 5'b0_0010 };
// psl12 cover_d_port_212 : cover { d_port12 == 5'b0_0100 };
// psl12 cover_d_port_312 : cover { d_port12 == 5'b0_1000 };
// psl12 cover_d_port_412 : cover { d_port12 == 5'b1_0000 };
// psl12 cover_d_port_all12 : cover { d_port12 == 5'b0_1111 };

`endif


endmodule
