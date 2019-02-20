library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity stack_memory is
    generic(
        WIDTH : natural := 32;
        DEPTH : natural := 256
    );
    port(
        I_DATA  : in  std_logic_vector(WIDTH - 1 downto 0); --Input Data Line
        O_DATA  : out std_logic_vector(WIDTH - 1 downto 0); --Output Data Line
        RD_stack : in  std_logic; --Input RD/~WR signal. 1 for READ, 0 for Write
	W_stack : in  std_logic;
        O_FULL  : out std_logic; --Output Full signal. 1 when memory is full.
        O_EMPTY : out std_logic; --Output Empty signal. 1 when memory is empty.
        clk     : in  std_logic;
        rst     : in  std_logic
    );
end entity stack_memory;

architecture RTL of stack_memory is
    -- Helper Function to convert Boolean to Std_logic
    function to_std_logic(B : boolean) return std_logic is
    begin
        if B = false then
            return '0';
        else
            return '1';
        end if;
    end function to_std_logic;

    type memory_type is array (0 to DEPTH - 1) of std_logic_vector(WIDTH - 1 downto 0);
    signal memory : memory_type;
begin
    main : process(clk, rst) is
        variable stack_pointer : integer range 0 to DEPTH := 0;
        variable EMPTY, FULL   : boolean   := false;

	
begin
        --Async Reset
        if rst = '1' then
            memory   <= (others => (others => '0'));
            EMPTY := true;
            FULL  := false;

            stack_pointer := 0;
        elsif (clk'event and clk = '1') then
	
	if ((not FULL) and (W_stack = '1')) then 
	 memory(stack_pointer) <= I_DATA;

	stack_pointer := stack_pointer + 1;
end if;
	elsif ((not EMPTY ) and (RD_stack = '1')) then 

	O_DATA <= memory(stack_pointer);

	stack_pointer := stack_pointer - 1;
end if;

 -- Check for Empty
            if stack_pointer = 0 then
                EMPTY := true;
            else
                EMPTY := false;
            end if;

 -- Check for Full
            if stack_pointer = DEPTH then
                FULL := true;
            else
                FULL := false;
            end if;
	
 	O_FULL  <= to_std_logic(FULL);
        O_EMPTY <= to_std_logic(EMPTY);
    end process main;

end architecture RTL;
	


