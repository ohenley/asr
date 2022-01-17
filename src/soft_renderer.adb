package body soft_renderer is

    procedure set_pixel_color (img : in out image; 
                                x  : natural; 
                                y  : natural;
                                c  : color) is
    begin
        img.r (x, y) := c.r;
        img.g (x, y) := c.g;
        img.b (x, y) := c.b;
        img.a (x, y) := c.a;
    end;

end soft_renderer;