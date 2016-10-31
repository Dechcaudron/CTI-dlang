module test.cti.cti_bird;

import cti;

import std.meta;

mixin CTInterface!(
    "CTIBird",
    CTIElement.method, "takeOff", bool,
    CTIElement.method, "land", void,
    CTIElement.method, "loseFeathers", void, int,

    CTIElement.readProperty, "feathers", int,
    CTIElement.writeProperty, "canTakeOff", bool,
    CTIElement.readWriteProperty, "isHungry", bool
);
