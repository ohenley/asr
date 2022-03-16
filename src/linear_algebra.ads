generic
    --type base is delta <>;
    type base is digits <>;
    
    --with function "+" (L, R : base) return base is <>;
    --with function "-" (L, R : base) return base is <>;
    --with function "*" (L, R : base) return base is <>;

    --type scalar is private;
    --with function "*" (L: base; R : scalar) return base;

package linear_algebra is
    type vec is array (natural range <>) of base;

    function "+" (left : vec; right : vec) return vec;
    function "-" (left : vec; right : vec) return vec;
    function "*" (left : vec; right : base) return vec;
    

    function dot (left: vec; right: vec) return base;
    function cross (a : vec; b : vec) return vec;

    procedure swap (left : in out vec; right : in out vec);

    procedure normalize (v : in out vec);

end linear_algebra;