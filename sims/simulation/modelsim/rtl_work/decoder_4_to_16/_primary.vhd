library verilog;
use verilog.vl_types.all;
entity decoder_4_to_16 is
    port(
        w_addr          : in     vl_logic_vector(3 downto 0);
        we              : in     vl_logic;
        we_dec          : out    vl_logic_vector(15 downto 0)
    );
end decoder_4_to_16;
