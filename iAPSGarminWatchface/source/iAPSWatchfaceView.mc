//**********************************************************************
// DESCRIPTION : Watch Faces for iAPS 
// AUTHORS : 
//          Created by ivalkou - https://github.com/ivalkou 
//          Modify by Pierre Lagarde - https://github.com/avouspierre
// COPYRIGHT : (c) 2023 ivalkou / Lagarde 
//

import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
using Toybox.Time.Gregorian as Calendar;
import Toybox.ActivityMonitor;
import Toybox.Activity;
import Toybox.Time;

class iAPSWatchfaceView extends WatchUi.WatchFace {
    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        System.println("onShow");
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {

        var status = Application.Storage.getValue("status") as Dictionary;

        setTime();
        setDate();
        setHeartRate();
        setSteps();
        setIOB(status);
        setCOB(status);
        setEventualBG(status);
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    function setTime() as Void {
        // Get the current time and format it correctly
        var timeFormat = "$1$:$2$";
        var clockTime = System.getClockTime();
        var hours = clockTime.hour;
        var suffix = "";
        if (!System.getDeviceSettings().is24Hour) {
            if (hours > 12) {
                hours = hours - 12;
                suffix = " PM";
            } else {
                suffix = " AM";
            }
        } else {
            timeFormat = "$1$:$2$";
            hours = hours.format("%02d");
        }
        var timeString = Lang.format(timeFormat + suffix, [hours, clockTime.min.format("%02d")]);

        // Update the view
        var view = View.findDrawableById("TimeLabel") as TextArea;
        view.setColor(getApp().getProperty("PrimaryColor") as Number);
        view.setText(timeString);
    }

    function setDate() as Void {
        var now = Time.now();
        var info = Calendar.info(now, Time.FORMAT_LONG);
        var dateStr = Lang.format("$1$ $2$ $3$", [info.day_of_week, info.month, info.day]);

        var view = View.findDrawableById("DateLabel") as TextArea;
        view.setColor(getApp().getProperty("PrimaryColor") as Number);
        view.setText(dateStr);
    }

    function setHeartRate() as Void {
        var info = Activity.getActivityInfo();
        var hr = info.currentHeartRate;

        var hrString = (hr == null) ? "--" : hr.toString();

        var view = View.findDrawableById("HRLabel") as Text;
        view.setText(hrString);
    }

    function setSteps() as Void {

        var myStats = System.getSystemStats();
        var batlevel = myStats.battery;
        var batString = Lang.format( "$1$%", [ batlevel.format( "%2d" ) ] );  
       
        var info =  ActivityMonitor.getInfo(); 
        var steps =   info.steps; 
        var stepsString = (steps == null || steps == 0) ? "--" : steps.toString();   
        
        var view = View.findDrawableById("StepsLabel") as Text;
        view.setText(batString);
    }

    function setIOB(status) as Void {
        var view = View.findDrawableById("IOBLabel") as Text;
        var iobString;
         if (status instanceof Dictionary)  {
            var iob = status["iob"];
            if (iob instanceof Number) {
                iobString = (iob == null) ? "--" : iob.format("%3.2f") + " U";
            } else {
                iobString = (iob == null) ? "--" : iob.toDouble().format("%3.2f") + " U";
            }
            
            view.setText(iobString);
            return;
            
        } else {
            view.setText("--");
            return;
        }  
    }

    function setCOB(status) as Void {
        var view = View.findDrawableById("COBLabel") as Text;

        if (status instanceof Dictionary)  {
            var cob = status["cob"];
            var cobString;
            if (cob instanceof Number) {
              cobString = (cob == null) ? "--" : cob.format("%3d") + " g";
            } else {
              cobString = (cob == null) ? "--" : cob.toDouble().format("%3d") + " g";
            }
            view.setText(cobString);
            return;
        } else {
            view.setText("--");
            return;
        }
        
    }

    function setEventualBG(status) as Void {
        var view = View.findDrawableById("EventualBGLabel") as Text;
        view.setColor(getApp().getProperty("PrimaryColor") as Number);

          if (status instanceof Dictionary)  {
            var ebg = status["eventualBGRaw"];
            if (ebg instanceof Number) {
                ebg = ebg.format("%d");
            }
            var ebgString = (ebg == null) ? "--" : ebg;
            view.setText(ebgString);
            return; 
        } else {
            view.setText("--");
            return;
        }
        
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }
}
