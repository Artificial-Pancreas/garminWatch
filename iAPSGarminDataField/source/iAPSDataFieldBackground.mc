//**********************************************************************
// DESCRIPTION : Background for data field for iAPS
// AUTHORS : 
//          Created by ivalkou - https://github.com/ivalkou 
//          Modify by Pierre Lagarde - https://github.com/avouspierre
// COPYRIGHT : (c) 2023 ivalkou / Lagarde 
//

import Toybox.Application;
import Toybox.Graphics;
import Toybox.WatchUi;

class Background extends WatchUi.Drawable {

    hidden var mColor as ColorValue;

    function initialize() {
        var dictionary = {
            :identifier => "Background"
        };
        Drawable.initialize(dictionary);
        mColor = Graphics.COLOR_WHITE;
    }

    function setColor(color as ColorValue) as Void {
        mColor = color;
    }

    function draw(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_WHITE, mColor);
        dc.clear();
    }

}
