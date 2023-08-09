library IEEE;
use IEEE.STD_LOGIC_1164.all;

package Componentes_pkg is

component Control is
	port (	clk, rst, inicia, per_listo: in std_logic;
				IND,men_1,men_2,rst_int,Guarda, Motor_listo: out std_logic);
end component;

component Memoria is
  port(	Temrx, Velrx, Periodo: in std_logic_vector (15 downto 0);
			rst, rst_int, rstx, IND, Guarda, etx: in std_logic;	
			V,T,P: out std_logic_vector (15 downto 0));
end component;

component Mensajes is
    port(  clk,rst,men_1,men_2: in STD_LOGIC;
           data:  inout STD_LOGIC_VECTOR( 0 to 3 );     
           LCD_E,LCD_RS,LCD_RW:  inout   STD_LOGIC;
           SF_CE0: out STD_LOGIC );
end component;

component GPS is
    Port (  clk,rst,IR,rst_int : in  STD_LOGIC;
				Motor_Listo: in std_logic;
				Periodo: out std_logic_vector (15 downto 0);
				Per_Listo: inout std_logic);
end component;

component PWM is
    Port (	clk,rst,IND,rst_int: in  STD_LOGIC;
				giro: out std_logic_vector(1 downto 0);
				sal_pwm : out std_logic);
end component;

component Trans is
port (	clk, rst: in  STD_LOGIC;
			tx : out  STD_LOGIC;	
			etx : inout STD_LOGIC;
			V, T, P : in std_logic_vector(15 downto 0));
end component;

component Recep is
    Port ( clk,rst,rx: in  std_logic;
			  Motor_Listo: in std_logic;
			  Temrx, Velrx:	out std_logic_vector(15 downto 0) );
end component;

component  Antirrebote is
    Port ( clk 	 : in  STD_LOGIC;
           captura : in  STD_LOGIC;
			  cap 	 : out STD_LOGIC);
end component;

component LCD_init is
    port( clk,rst: in STD_LOGIC;
          LCD_E, LCD_RS, LCD_RW:  inout   STD_LOGIC;
	       listo: out STD_LOGIC;
          DATA:  inout STD_LOGIC_VECTOR( 0 to 3 ) );
end component;

component mensaje1 is
    port( clk,rst,listo_in: in STD_LOGIC;
          LCD_E, LCD_RS, LCD_RW:  inout   STD_LOGIC;
	       listo_out: out STD_LOGIC;
          DATA:  inout STD_LOGIC_VECTOR( 0 to 3 ) );
end component;

component mensaje2 is
    port( clk,rst,listo_in: in STD_LOGIC;
          LCD_E, LCD_RS, LCD_RW:  inout   STD_LOGIC;
	       listo_out: out STD_LOGIC;
          DATA:  inout STD_LOGIC_VECTOR( 0 to 3 ) );
end component;

component mensaje3 is
    port( clk,rst,listo_in: in STD_LOGIC;
          LCD_E, LCD_RS, LCD_RW:  inout   STD_LOGIC;
	       listo_out: out STD_LOGIC;
          DATA:  inout STD_LOGIC_VECTOR( 0 to 3 ) );
end component;

component mensaje4 is
    port( clk,rst,listo_in: in STD_LOGIC;
          LCD_E, LCD_RS, LCD_RW:  inout   STD_LOGIC;
	       listo_out: out STD_LOGIC;
          DATA:  inout STD_LOGIC_VECTOR( 0 to 3 ) );
end component;

component mensaje5 is
    port( clk,rst,listo_in: in STD_LOGIC;
          LCD_E, LCD_RS, LCD_RW:  inout   STD_LOGIC;
	       listo_out: out STD_LOGIC;
          DATA:  inout STD_LOGIC_VECTOR( 0 to 3 ) );
end component;

component mensaje6 is
    port( clk,rst,listo_in: in STD_LOGIC;
          LCD_E, LCD_RS, LCD_RW:  inout   STD_LOGIC;
	       listo_out: out STD_LOGIC;
          DATA:  inout STD_LOGIC_VECTOR( 0 to 3 ) );
end component;

component mensaje7 is
    port( clk,rst,listo_in: in STD_LOGIC;
          LCD_E, LCD_RS, LCD_RW:  inout   STD_LOGIC;
			 listo_out: out STD_LOGIC;
          DATA:  inout STD_LOGIC_VECTOR( 0 to 3 ) );
end component;

component entrada is
	 port(  clk,rst: in STD_LOGIC;
		     V,T,P: out STD_LOGIC_VECTOR(15 downto 0));
end component;

component serial is
  port ( clk, rst: in  STD_LOGIC;
         V,T,P: in STD_LOGIC_VECTOR(15 downto 0);
         etx: inout STD_LOGIC;
		   tx: out  STD_LOGIC);	
end component;

component generador is 
  port ( clk, rst: in std_logic;
         etx: inout std_logic);
end component;


end Componentes_pkg;