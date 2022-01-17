with system;
with interfaces.c;
with Interfaces.C.Strings;
with ada.text_io; use ada.text_io;
package body x11_window is

    package ic renames interfaces.c;
    package ics renames Interfaces.C.Strings;

    type display_access is new system.address; -- Display*
    type window is new ic.unsigned_long;    -- typedef to XID to unsigned long
    type xevent is array (1..24) of ic.long; -- union with wider being: long pad[24];
    type xevent_access is access all xevent;

    type graphic_context is new system.address;
    type xgcvalues_access is new system.address;

    ExposureMask : constant ic.unsigned_long := 32768;
    KeyPressMask : constant ic.unsigned_long := 1;

    type bool is new boolean;
    for bool'size use 8;


    function x_open_display (display_name : ics.chars_ptr) return display_access with
        Import        => True,
        Convention    => c,
        External_Name => "XOpenDisplay";

    function x_default_screen (display : display_access) return ic.int with
        Import        => True,
        Convention    => c,
        External_Name => "XDefaultScreen";

    function x_default_root_window (display : display_access) return window with
        Import        => True,
        Convention    => c,
        External_Name => "XDefaultRootWindow";

    function x_black_pixel (display : display_access; screen_number : ic.int) return ic.unsigned_long with
        Import        => True,
        Convention    => c,
        External_Name => "XBlackPixel";

    function x_create_simple_window (display : display_access;
                                    parent : window;
                                    x : ic.int;
                                    y : ic.int;
                                    width : ic.unsigned;
                                    height : ic.unsigned;
                                    border_width : ic.unsigned;
                                    border : ic.unsigned_long;
                                    background : ic.unsigned_long) return window with
        Import        => True,
        Convention    => c,
        External_Name => "XCreateSimpleWindow";

    procedure x_select_input (display : display_access; w : window; event_mash : ic.long) with
        Import        => True,
        Convention    => c,
        External_Name => "XSelectInput";

    procedure x_map_window (display : display_access; w : window) with
        Import        => True,
        Convention    => c,
        External_Name => "XMapWindow";

    function x_create_graphic_context (display : display_access; w : window; value_mask : ic.unsigned_long; values : xgcvalues_access) return graphic_context with
        Import        => True,
        Convention    => c,
        External_Name => "XCreateGC";

    procedure x_set_foreground (display : display_access; gc : graphic_context; foreground : ic.unsigned_long) with
        Import        => True,
        Convention    => c,
        External_Name => "XSetForeground";

    procedure x_draw_point (display : display_access; w : window; gc : graphic_context; x : ic.int; y : ic.int) with
        Import        => True,
        Convention    => c,
        External_Name => "XDrawPoint";

    procedure x_next_event (display : display_access;  event_return : xevent_access) with
        Import        => True,
        Convention    => c,
        External_Name => "XNextEvent";

    procedure x_send_event (display : display_access; w : window; propagate : bool; event_mask : ic.long; event_send : xevent_access) with
        Import        => True,
        Convention    => c,
        External_Name => "XSendEvent";


    procedure open_window (image : soft_renderer.image) is
        use ic;
        dpy : display_access := x_open_display(ics.null_ptr);
        screen_num : ic.int := x_default_screen (dpy);
        rwin : window := x_default_root_window (dpy);
        win : window := x_create_simple_window (dpy, rwin, 0, 0, 600, 600, 1, x_black_pixel (dpy, screen_num), x_black_pixel (dpy, screen_num));
        event : aliased xevent;
        gc : graphic_context;
        mask : ic.unsigned_long := KeyPressMask or ExposureMask;
        quit : boolean := false;

        procedure draw_pixel (x : ic.int; y : ic.int; color : ic.unsigned_long)  is
        begin
            x_set_foreground (dpy, gc, color);
            x_draw_point (dpy, win, gc, x, y);
        end;

        x0, y0 : ic.int := 0;

        use soft_renderer;
    begin
        x_map_window (dpy, win);
        x_select_input (dpy, win, ic.long(mask));

        gc := x_create_graphic_context (dpy, rwin, 0, xgcvalues_access(system.Null_Address));

        while not quit loop
            x_next_event (dpy, event'unchecked_access);

            for i in image.r'range (1) loop
                for j in image.r'range (2) loop
                    if image.r (i, j) = 1.0 then
                        draw_pixel (ic.int(i), ic.int(j), 16#ffffff#);
                    end if;
                end loop;
            end loop;



            -- force animation loop
            -- delay 0.0083;
            -- x_send_event (dpy, win, true, 0, event'unchecked_access);
        end loop;
    end;

end x11_window; 