----------------------------------------------------------------------------------
-- Escuela: 		E.S.I.M.E. IPN
-- Programadores: Luis Sanchez Marquez
--						Ricardo Flores Martinez
-- Asesor: 			M. en C. Luis Martin Flores Nava
-- Proyecto:   	TESIS
-- Modulo:     	Gyro_Tech
-- Descripción: 	Programa principal de enlace de modulos
-----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.Componentes_pkg.ALL;

entity Gyro_Tech is
    Port( clk, rst, rstx, Rx, IR, inicia: in STD_LOGIC;
          data:  inout STD_LOGIC_VECTOR( 0 to 3 );
          giro: out 	STD_LOGIC_VECTOR( 1 downto 0);		 
          LCD_E, LCD_RS, LCD_RW, per_listo:  inout   STD_LOGIC;
          SF_CE0, Tx, pwm: out STD_LOGIC );
end Gyro_Tech;

architecture Arq of Gyro_Tech is

signal IND, Motor_listo, men_1, men_2, rst_int, guarda, etx: std_logic;
signal Temrx, Velrx, periodo, V, T, P : std_logic_vector (15 downto 0);

begin

mod_1: Control  port map (clk, rst, inicia, per_listo, IND, men_1, men_2, rst_int, guarda, Motor_listo );
mod_2: Memoria  port map (Temrx, Velrx, periodo, rst, rst_int, rstx, IND, guarda, etx, V, T, P );
mod_3: Recep    port map (clk, rst, Rx, Motor_listo, Temrx, Velrx );
mod_4: GPS      port map (clk, rst, IR, rst_int, Motor_listo, periodo, per_listo);
mod_5: PWM      port map (clk, rst, IND, rst_int, giro, pwm);
mod_6: Mensajes port map (clk, rst, men_1, men_2, data, LCD_E, LCD_RS, LCD_RW, SF_CE0 );
mod_7: Trans    port map (clk, rstx, Tx, etx, V, T, P );

end Arq;

