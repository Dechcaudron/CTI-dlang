module cti.implements_cti;

import std.traits;
import std.format;
import std.meta;

import cti.cti_element;

public pure bool implementsCTI(T, CTI)()
{
    alias description = CTI.description;

    /* Stop at each of the CTIElements in the AliasSeq and look into them */
    foreach (int a, descriptionElement; description)
    {
        pragma(msg, format("a is %s", a));

        static if (is (typeof(descriptionElement) : CTIElement))
            foreach (int i, descriptionElement2; description)
            {
                pragma(msg, format("i is %s", i));
                /* Find the next CTIElement in the AliasSeq, or the last
                   element and check if implementation is correct */
                static if ( (is (typeof(descriptionElement2) : CTIElement) &&
                             i > a))
                {
                    static if(!implementsMember!(T, description[a..i]))
                        return false;
                    else
                    {
                        //pragma(msg, "Should break");
                        break; //It doesn't break the CT loop, so I'll find a workaround
                    }

                }
                else static if (i == description.length - 1)
                    static if(!implementsMember!(T, description[a..i+1]))
                        return false;
            }
    }

    return true;
}

private pure bool implementsMember(T, Ts...)()
{
    static assert (is (typeof(Ts[0]) : CTIElement));

    pragma(msg, format("Checking if %s implements %s", T.stringof, Ts.stringof));

    import std.conv;

    with (CTIElement) final switch(to!CTIElement(Ts[0]))
    {
        case method:
            return implementsMethod!(T, Ts[1..$]);

        case readProperty:
            return implementsReadProperty!(T, Ts[1..$]);

        case writeProperty:
            return implementsWriteProperty!(T, Ts[1..$]);

        case readWriteProperty:
            return implementsReadWriteProperty!(T, Ts[1..$]);

    }
}

private pure bool implementsMethod(T, Ts...)()
{
    pragma(msg, format("Checking if %s implements method %s", T.stringof, Ts.stringof));

    static assert (is(typeof(Ts[0]) : string));
    alias methodName = Alias!(Ts[0]);

    static assert (is(Ts[1]));
    alias returnT = Ts[1];

    static assert (isTypeTuple!(Ts[2..$]));
    alias argTs = Ts[2..$];

    T t;

    static if (!__traits(hasMember, T, methodName))
    {
        pragma(msg, "No member found for that name");
        return false;
    }

    alias functionExpression = Alias!(__traits(getMember, T, methodName));

    static if (!isCallable!(functionExpression))
    {
        pragma(msg, "Member is not callable");
        return false;
    }

    static if (!is (ReturnType!functionExpression : returnT))
    {
        pragma(msg, "Return type does not match");
        return false;
    }

    static if (!is(Parameters!functionExpression : argTs))
    {
        pragma(msg, "Argument types don't match");
        return false;
    }

    return true;
}

private pure bool implementsReadWriteProperty(T, Ts...)()
{
    return implementsReadProperty!(T, Ts) &&
           implementsWriteProperty!(T, Ts);
}

private pure bool implementsReadProperty(T, Ts...)()
{
    return true;
}

private pure bool implementsWriteProperty(T, Ts...)()
{
    return true;
}
