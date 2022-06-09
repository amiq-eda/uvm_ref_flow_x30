//File27 name   : alut27.v
//Title27       : ALUT27 top level
//Created27     : 1999
//Description27 : 
//Notes27       : 
//----------------------------------------------------------------------
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------
module alut27
(   
   // Inputs27
   pclk27,
   n_p_reset27,
   psel27,            
   penable27,       
   pwrite27,         
   paddr27,           
   pwdata27,          

   // Outputs27
   prdata27  
);

   parameter   DW27 = 83;          // width of data busses27
   parameter   DD27 = 256;         // depth of RAM27


   // APB27 Inputs27
   input             pclk27;               // APB27 clock27                          
   input             n_p_reset27;          // Reset27                              
   input             psel27;               // Module27 select27 signal27               
   input             penable27;            // Enable27 signal27                      
   input             pwrite27;             // Write when HIGH27 and read when LOW27  
   input [6:0]       paddr27;              // Address bus for read write         
   input [31:0]      pwdata27;             // APB27 write bus                      

   output [31:0]     prdata27;             // APB27 read bus                       

   wire              pclk27;               // APB27 clock27                           
   wire [7:0]        mem_addr_add27;       // hash27 address for R/W27 to memory     
   wire              mem_write_add27;      // R/W27 flag27 (write = high27)            
   wire [DW27-1:0]     mem_write_data_add27; // write data for memory             
   wire [7:0]        mem_addr_age27;       // hash27 address for R/W27 to memory     
   wire              mem_write_age27;      // R/W27 flag27 (write = high27)            
   wire [DW27-1:0]     mem_write_data_age27; // write data for memory             
   wire [DW27-1:0]     mem_read_data_add27;  // read data from mem                 
   wire [DW27-1:0]     mem_read_data_age27;  // read data from mem  
   wire [31:0]       curr_time27;          // current time
   wire              active;             // status[0] adress27 checker active
   wire              inval_in_prog27;      // status[1] 
   wire              reused27;             // status[2] ALUT27 location27 overwritten27
   wire [4:0]        d_port27;             // calculated27 destination27 port for tx27
   wire [47:0]       lst_inv_addr_nrm27;   // last invalidated27 addr normal27 op
   wire [1:0]        lst_inv_port_nrm27;   // last invalidated27 port normal27 op
   wire [47:0]       lst_inv_addr_cmd27;   // last invalidated27 addr via cmd27
   wire [1:0]        lst_inv_port_cmd27;   // last invalidated27 port via cmd27
   wire [47:0]       mac_addr27;           // address of the switch27
   wire [47:0]       d_addr27;             // address of frame27 to be checked27
   wire [47:0]       s_addr27;             // address of frame27 to be stored27
   wire [1:0]        s_port27;             // source27 port of current frame27
   wire [31:0]       best_bfr_age27;       // best27 before age27
   wire [7:0]        div_clk27;            // programmed27 clock27 divider27 value
   wire [1:0]        command;            // command bus
   wire [31:0]       prdata27;             // APB27 read bus
   wire              age_confirmed27;      // valid flag27 from age27 checker        
   wire              age_ok27;             // result from age27 checker 
   wire              clear_reused27;       // read/clear flag27 for reused27 signal27           
   wire              check_age27;          // request flag27 for age27 check
   wire [31:0]       last_accessed27;      // time field sent27 for age27 check




alut_reg_bank27 i_alut_reg_bank27
(   
   // Inputs27
   .pclk27(pclk27),
   .n_p_reset27(n_p_reset27),
   .psel27(psel27),            
   .penable27(penable27),       
   .pwrite27(pwrite27),         
   .paddr27(paddr27),           
   .pwdata27(pwdata27),          
   .curr_time27(curr_time27),
   .add_check_active27(add_check_active27),
   .age_check_active27(age_check_active27),
   .inval_in_prog27(inval_in_prog27),
   .reused27(reused27),
   .d_port27(d_port27),
   .lst_inv_addr_nrm27(lst_inv_addr_nrm27),
   .lst_inv_port_nrm27(lst_inv_port_nrm27),
   .lst_inv_addr_cmd27(lst_inv_addr_cmd27),
   .lst_inv_port_cmd27(lst_inv_port_cmd27),

   // Outputs27
   .mac_addr27(mac_addr27),    
   .d_addr27(d_addr27),   
   .s_addr27(s_addr27),    
   .s_port27(s_port27),    
   .best_bfr_age27(best_bfr_age27),
   .div_clk27(div_clk27),     
   .command(command), 
   .prdata27(prdata27),  
   .clear_reused27(clear_reused27)           
);


alut_addr_checker27 i_alut_addr_checker27
(   
   // Inputs27
   .pclk27(pclk27),
   .n_p_reset27(n_p_reset27),
   .command(command),
   .mac_addr27(mac_addr27),
   .d_addr27(d_addr27),
   .s_addr27(s_addr27),
   .s_port27(s_port27),
   .curr_time27(curr_time27),
   .mem_read_data_add27(mem_read_data_add27),
   .age_confirmed27(age_confirmed27),
   .age_ok27(age_ok27),
   .clear_reused27(clear_reused27),

   //outputs27
   .d_port27(d_port27),
   .add_check_active27(add_check_active27),
   .mem_addr_add27(mem_addr_add27),
   .mem_write_add27(mem_write_add27),
   .mem_write_data_add27(mem_write_data_add27),
   .lst_inv_addr_nrm27(lst_inv_addr_nrm27),
   .lst_inv_port_nrm27(lst_inv_port_nrm27),
   .check_age27(check_age27),
   .last_accessed27(last_accessed27),
   .reused27(reused27)
);


alut_age_checker27 i_alut_age_checker27
(   
   // Inputs27
   .pclk27(pclk27),
   .n_p_reset27(n_p_reset27),
   .command(command),          
   .div_clk27(div_clk27),          
   .mem_read_data_age27(mem_read_data_age27),
   .check_age27(check_age27),        
   .last_accessed27(last_accessed27), 
   .best_bfr_age27(best_bfr_age27),   
   .add_check_active27(add_check_active27),

   // outputs27
   .curr_time27(curr_time27),         
   .mem_addr_age27(mem_addr_age27),      
   .mem_write_age27(mem_write_age27),     
   .mem_write_data_age27(mem_write_data_age27),
   .lst_inv_addr_cmd27(lst_inv_addr_cmd27),  
   .lst_inv_port_cmd27(lst_inv_port_cmd27),  
   .age_confirmed27(age_confirmed27),     
   .age_ok27(age_ok27),
   .inval_in_prog27(inval_in_prog27),            
   .age_check_active27(age_check_active27)
);   


alut_mem27 i_alut_mem27
(   
   // Inputs27
   .pclk27(pclk27),
   .mem_addr_add27(mem_addr_add27),
   .mem_write_add27(mem_write_add27),
   .mem_write_data_add27(mem_write_data_add27),
   .mem_addr_age27(mem_addr_age27),
   .mem_write_age27(mem_write_age27),
   .mem_write_data_age27(mem_write_data_age27),

   .mem_read_data_add27(mem_read_data_add27),  
   .mem_read_data_age27(mem_read_data_age27)
);   



`ifdef ABV_ON27
// psl27 default clock27 = (posedge pclk27);

// ASSUMPTIONS27

// ASSERTION27 CHECKS27
// the invalidate27 aged27 in progress27 flag27 and the active flag27 
// should never both be set.
// psl27 assert_inval_in_prog_active27 : assert never (inval_in_prog27 & active);

// it should never be possible27 for the destination27 port to indicate27 the MAC27
// switch27 address and one of the other 4 Ethernets27
// psl27 assert_valid_dest_port27 : assert never (d_port27[4] & |{d_port27[3:0]});

// COVER27 SANITY27 CHECKS27
// check all values of destination27 port can be returned.
// psl27 cover_d_port_027 : cover { d_port27 == 5'b0_0001 };
// psl27 cover_d_port_127 : cover { d_port27 == 5'b0_0010 };
// psl27 cover_d_port_227 : cover { d_port27 == 5'b0_0100 };
// psl27 cover_d_port_327 : cover { d_port27 == 5'b0_1000 };
// psl27 cover_d_port_427 : cover { d_port27 == 5'b1_0000 };
// psl27 cover_d_port_all27 : cover { d_port27 == 5'b0_1111 };

`endif


endmodule
