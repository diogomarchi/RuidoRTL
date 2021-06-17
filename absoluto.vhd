------------------------------------------------
-- Design: contador
-- Entity: contador
-- Author: Diogo & George
-- Rev. : 1.0
-- Date : 03/14/2021
------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

ENTITY absoluto IS
  PORT (
    i_A    : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);-- data input		 
    o_SAIDA : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) -- data output
  );
END absoluto;

ARCHITECTURE rtl OF absoluto IS

BEGIN
  PROCESS (i_A)
  BEGIN
        o_SAIDA <= std_logic_vector(abs(signed(i_A)));
  END PROCESS;

END rtl;
