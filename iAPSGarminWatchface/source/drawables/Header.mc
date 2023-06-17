//**********************************************************************
// DESCRIPTION : Header for Watch Faces for iAPS 
// AUTHORS : 
//          Created by ivalkou - https://github.com/ivalkou 
//          Modify by Pierre Lagarde - https://github.com/avouspierre
// COPYRIGHT : (c) 2023 ivalkou / Lagarde 
//

import Toybox.Lang;
import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Application;
import Toybox.Time;

class HeaderDrawable extends WatchUi.Drawable {
    function initialize() {
        var dictionary = {
            :identifier => "HeaderDrawable"
        };

        Drawable.initialize(dictionary);
    }

    function draw(dc as Dc) as Void {
        if(dc has :setAntiAlias) {
            dc.setAntiAlias(true);
        }
        var width = dc.getWidth() as Number;
        var height = dc.getHeight() as Number;
        var primaryColor = getApp().getProperty("PrimaryColor") as Number;
        var status = Application.Storage.getValue("status") as Dictionary;
        var glucoseText = getGlucoseText(status);
        var deltaText = getDeltaText(status);
        var glucoseWidth = dc.getTextWidthInPixels(glucoseText, Graphics.FONT_LARGE) as Number;
        var glucoseHeight = dc.getFontHeight(Graphics.FONT_LARGE) as Number;
        var deltaHeight = dc.getFontHeight(Graphics.FONT_XTINY) as Number;

        var glucoseX = width * 0.6;
        var glucoseY = height * 0.23;
        
        dc.setColor(primaryColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(glucoseX , glucoseY, Graphics.FONT_LARGE, glucoseText, Graphics.TEXT_JUSTIFY_LEFT);

        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);

        dc.drawText(glucoseX  + glucoseWidth + width * 0.01, 
            glucoseY + (glucoseHeight - deltaHeight) - deltaHeight * 0.1, 
            Graphics.FONT_SYSTEM_XTINY,
            deltaText, 
            Graphics.TEXT_JUSTIFY_LEFT);
        
        
        //fenix 5 not display 
        dc.drawBitmap(glucoseX  + glucoseWidth + width * 0.01, glucoseY + height * 0.025, getDirection(status));

        var min = getMinutes(status);
        var loopColor = getLoopColor(min);

        dc.setColor(loopColor, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(6);
       // dc.drawCircle(width * 0.55 + glucoseHeight * 0.3, glucoseY + glucoseHeight / 2, glucoseHeight * 0.3);
        dc.drawCircle(width * 0.1 + glucoseHeight * 0.3, glucoseY + glucoseHeight / 2, glucoseHeight * 0.3);

        var loopString = (min < 0 ? "--" : min.format("%d")) + " min";
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        // dc.drawText(width * 0.85, 
        //fenix 5 --> change 0.4 by 0.45
        dc.drawText(width * 0.4, 
            glucoseY + (glucoseHeight - deltaHeight) - deltaHeight * 0.2, 
            Graphics.FONT_XTINY, 
            loopString, 
            Graphics.TEXT_JUSTIFY_RIGHT);
    }

    function getGlucoseText(status) as String {
        
        if (status instanceof Dictionary)  {
            var bg = status["glucose"] as String;
            var bgString = (bg == null) ? "--" : bg;
            return bgString;
          
        } else {
              return "--";
        }
        
    }

    function getDeltaText(status) as String {
        
       if (status instanceof Dictionary)  {
            var delta = status["delta"] as String;
            var deltaString = (delta == null) ? "--" : delta;
            return deltaString;
           
        } else {
             return "--";
        }
        
    }

    function getDirection(status) as BitmapType {
        var bitmap = WatchUi.loadResource(Rez.Drawables.Unknown);
        if (status instanceof Dictionary)  {
            var trend = status["trendRaw"] as String;
            if (trend == null) {
                return bitmap;
            }

            switch (trend) {
                case "Flat":
                    bitmap = WatchUi.loadResource(Rez.Drawables.Flat);
                    break;
                case "SingleUp":
                    bitmap = WatchUi.loadResource(Rez.Drawables.SingleUp);
                    break;
                case "SingleDown":
                    bitmap = WatchUi.loadResource(Rez.Drawables.SingleDown);
                    break;
                case "FortyFiveUp":
                    bitmap = WatchUi.loadResource(Rez.Drawables.FortyFiveUp);
                    break;
                case "FortyFiveDown":
                    bitmap = WatchUi.loadResource(Rez.Drawables.FortyFiveDown);
                    break;
                case "DoubleUp":
                case "TripleUp":
                    bitmap = WatchUi.loadResource(Rez.Drawables.DoubleUp);
                    break;
                case "DoubleDown":
                case "TripleDown":
                    bitmap = WatchUi.loadResource(Rez.Drawables.DoubleDown);
                    break;
                default: break;
            }

            return bitmap;
        } else {
            return bitmap;
        }
        
    }

    function getMinutes(status) as Number {
       
        if (status instanceof Dictionary)  {
            var lastLoopDate = status["lastLoopDateInterval"] as Number;
            if (lastLoopDate == null) {
                return -1;
            }

            var now = Time.now().value() as Number;
            
            var min = (now - lastLoopDate) / 60;

            return min;
        } else {
            return -1;
        }
        
    }

    function getLoopColor(min as Number) as Number {
        if (min < 0) {
            return Graphics.COLOR_LT_GRAY as Number;
        } else if (min <= 5) {
            return Graphics.COLOR_GREEN as Number;
        } else if (min <= 10) {
            return Graphics.COLOR_YELLOW as Number;
        } else {
            return Graphics.COLOR_RED as Number;
        }
    } 
}