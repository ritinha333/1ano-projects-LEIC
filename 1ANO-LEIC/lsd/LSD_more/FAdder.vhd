library ieee; 
 use ieee.std_logic_1164.all; 
 
 entity FAdder is  
   port( 
  A, B, Ci: in std_logic;  
  S, CO: out std_logic
  );  
 end FAdder;
 
 architecture arq_FAdder of FAdder is 
 
 begin     
   CO <= (A and B) or (A and Ci) or (B and Ci);  
   S <= A xor B xor Ci;
	
 end arq_FAdder; 