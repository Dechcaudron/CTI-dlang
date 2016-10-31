module test.cti.bird_impl_1;

import cti;
import test.cti.cti_bird;

@CTIBird
public struct BirdImpl1
{
    static assert (implementsCTI!(typeof(this), CTIBird));

    private int _feathers;
    @property public int feathers()
    { return _feathers; }

    private bool _canTakeOff;
    @property public void canTakeOff(bool can)
    { _canTakeOff = can; }

    private bool _isHungry;
    @property public bool isHungry()
    { return _isHungry; }
    @property public void isHungry(bool hungry)
    { _isHungry = hungry; }

    public void takeOff()
    {
        //return _canTakeOff;
    }

    public void land()
    {

    }

    public void loseFeathers(int number)
    {
        _feathers -= number;
    }
}
