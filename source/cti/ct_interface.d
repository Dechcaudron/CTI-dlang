module cti.ct_interface;

mixin template CTInterface(Ts...)
if( checkCTInterfaceArgs!Ts )
{
    import std.format : format;

    mixin (format("alias %s = CTInterfaceT!(Ts[1..$]);", Ts[0]));

    struct CTInterfaceT(Ts...)
    {
        alias name = Ts[0];
        alias description = Ts[1..$];
    }
}

private pure bool checkCTInterfaceArgs(Ts...)()
{
    import std.format;
    import cti.cti_element;

    static assert ( is (typeof(Ts[0]) : string ),
    format("First argument of the CTI description must be a CT-known string " ~
    "expression with the name of the interface. Given: %s", Ts[0].stringof));

    static assert( is (typeof(Ts[1]) : CTIElement) ,
    format("Second argument of the CTI description must be a member of the " ~
    "CTIElement enum. Given: %s", Ts[1].stringof));

    return true;
}
