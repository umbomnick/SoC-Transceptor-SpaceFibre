library verilog;
use verilog.vl_types.all;
entity register_8bit is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        we              : in     vl_logic;
        d_in            : in     vl_logic_vector(7 downto 0);
        q_out           : out    vl_logic_vector(7 downto 0)
    );
end register_8bit;
