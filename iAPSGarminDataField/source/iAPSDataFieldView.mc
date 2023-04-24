//**********************************************************************
// DESCRIPTION : DataField for iAPS 
// AUTHORS : 
//          Created by ivalkou - https://github.com/ivalkou 
//          Modify by Pierre Lagarde - https://github.com/avouspierre
// COPYRIGHT : (c) 2023 ivalkou / Lagarde 
//

import Toybox.Activity;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;


class iAPSDataFieldView extends WatchUi.DataField {

   
    function initialize() {
        DataField.initialize();
       
    }

    // Set your layout here. Anytime the size of obscurity of
    // the draw context is changed this will be called.
    function onLayout(dc as Dc) as Void {
        var obscurityFlags = DataField.getObscurityFlags();

        // Top left quadrant so we'll use the top left layout
        if (obscurityFlags == (OBSCURE_TOP | OBSCURE_LEFT)) {
            View.setLayout(Rez.Layouts.TopLeftLayout(dc));

        // Top right quadrant so we'll use the top right layout
        } else if (obscurityFlags == (OBSCURE_TOP | OBSCURE_RIGHT)) {
            View.setLayout(Rez.Layouts.TopRightLayout(dc));

        // Bottom left quadrant so we'll use the bottom left layout
        } else if (obscurityFlags == (OBSCURE_BOTTOM | OBSCURE_LEFT)) {
            View.setLayout(Rez.Layouts.BottomLeftLayout(dc));

        // Bottom right quadrant so we'll use the bottom right layout
        } else if (obscurityFlags == (OBSCURE_BOTTOM | OBSCURE_RIGHT)) {
            View.setLayout(Rez.Layouts.BottomRightLayout(dc));

        // Use the generic, centered layout
        } else {
            View.setLayout(Rez.Layouts.MainLayout(dc));
            var labelView = View.findDrawableById("label");
            labelView.locX = labelView.locX - 40;
            labelView.locY = labelView.locY - 10;
            var valueView = View.findDrawableById("value");
             valueView.locX = valueView.locX + 5;
            valueView.locY = valueView.locY - 10;
            var valueViewTime = View.findDrawableById("valueTime");
            valueViewTime.locX = valueViewTime.locX  + 10 ;
            valueViewTime.locY = valueViewTime.locY + 20; 
            var valueViewDelta = View.findDrawableById("valueDelta"); 
            valueViewDelta.locX = valueViewDelta.locX - 40;   
            valueViewDelta.locY = valueViewDelta.locY + 20;   

        }

        (View.findDrawableById("label") as Text).setText(Rez.Strings.label);
    }

    // The given info object contains all the current workout information.
    // Calculate a value and save it locally in this method.
    // Note that compute() and onUpdate() are asynchronous, and there is no
    // guarantee that compute() will be called before onUpdate().
    function compute(info as Activity.Info) as Void {
        // See Activity.Info in the documentation for available information.
        
    }

    // Display the value you computed here. This will be called
    // once a second when the data field is visible.
    function onUpdate(dc as Dc) as Void {
        var bgString;
        var loopColor;
        var loopString;
        var deltaString;

        var status = Application.Storage.getValue("status") as Dictionary;

        if (status == null) {
            bgString = "---";
            loopColor = getLoopColor(-1);
            loopString = "(xx)";
            deltaString = "??";
        } else {
            var bg = status["glucose"] as String;
            bgString = (bg == null) ? "--" : bg as String;
            var min = getMinutes(status);
            loopColor = getLoopColor(min);
            loopString = (min < 0 ? "(--)" : "(" + min.format("%d")) + " mn)" as String;
            deltaString = getDeltaText(status) as String; 
        }
        // Set the background color
        //View.findDrawableById("Background").setColor(loopColor);
        (View.findDrawableById("Background") as Text).setColor(loopColor);    //getBackgroundColor());
      
        // Set the foreground color and value
        var value = View.findDrawableById("value") as Text;
        var valueTime = View.findDrawableById("valueTime") as Text;
        var valueDelta = View.findDrawableById("valueDelta") as Text;
        if (getBackgroundColor() == Graphics.COLOR_BLACK) {
            value.setColor(Graphics.COLOR_WHITE);
            valueTime.setColor(Graphics.COLOR_WHITE);
            valueDelta.setColor(Graphics.COLOR_WHITE);
        } else {
            value.setColor(Graphics.COLOR_BLACK);
            valueTime.setColor(Graphics.COLOR_BLACK);
            valueDelta.setColor(Graphics.COLOR_BLACK);
        }
        value.setText(bgString);
        valueDelta.setText(deltaString);
        valueTime.setText(loopString);

        // Call parent's onUpdate(dc) to redraw the layout
        View.onUpdate(dc);
    }

    function getMinutes(status as Dictionary) as Number {
        //var status = Application.Storage.getValue("status") as Dictionary;
        //System.print(Time.now().value());
        if (status == null) {
            return -1;
        }
        var lastLoopDate = status["lastLoopDateInterval"] as Number;

        if (lastLoopDate == null) {
            return -1;
        }

        if (lastLoopDate instanceof Number) {
            

            var now = Time.now().value() as Number;
            
            var min = (now - lastLoopDate) / 60;
            return min;
        } else {
            return -1;
        }
    }

    function getLoopColor(min as Number) as Number {
        if (min < 0) {
            return Graphics.COLOR_WHITE as Number;
        } else if (min <= 5) {
            return Graphics.COLOR_WHITE as Number;
            // return Graphics.COLOR_GREEN as Number;
        } else if (min <= 10) {
            return Graphics.COLOR_YELLOW as Number;
        } else {
            return Graphics.COLOR_RED as Number;
        }
    } 

    function getDeltaText(status as Dictionary) as String {
        // var status = Application.Storage.getValue("status") as Dictionary;
        if (status == null) {
            return "--";
        }
        var delta = status["delta"] as String;

        var deltaString = (delta == null) ? "--" : delta;

        return deltaString;
    }

}
