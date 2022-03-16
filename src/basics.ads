package basics is
    --type real is delta 2.0**(-64) range -1_000_000.0 .. 1_000_000.0;
    type real is new float;
    --type intensity is digits 3 range 0.0 .. 1.0;
    --type intensity is delta 2.0**(-8) range 0.0 .. 1.0;
    --for intensity'size use 8;

    small : constant := 2.0**(-7);
    first : constant := small;
    last  : constant := +1.0 + small;
--
    type intensity is delta small range first .. last;
    for intensity'small use small;
    for intensity'size  use 8;
   -- type intensity is new float;

    generic
        type t is private;
    procedure generic_swap (x, y : in out t);

end basics;