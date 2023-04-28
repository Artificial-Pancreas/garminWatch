//**********************************************************************
// DESCRIPTION : Application for data field for iAPS
// AUTHORS : 
//          Created by ivalkou - https://github.com/ivalkou 
//          Modify by Pierre Lagarde - https://github.com/avouspierre
// COPYRIGHT : (c) 2023 ivalkou / Lagarde 
//

import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Background;
import Toybox.Time;
import Toybox.System;
import Toybox.Communications;

class iAPSDataFieldApp extends Application.AppBase {

    var phoneCallback;

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
        //register for temporal events if they are supported
    if(Toybox.System has :ServiceDelegate) {
            // canDoBG=true;
            Background.registerForTemporalEvent(new Time.Duration(5 * 60));
            if (Background has :registerForPhoneAppMessageEvent) {
                Background.registerForPhoneAppMessageEvent();
                System.println("****background is ok****");
            } else {
                  System.println("****registerForPhoneAppMessageEvent is not available****");
            }
            
        } else {
            System.println("****background not available on this device****");
        }
    }

    function onBackgroundData(data) {
        // for Fenix5
        //Application.Storage.setValue("status", data as Dictionary);
        WatchUi.requestUpdate();
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    //! Return the initial view of your application here
    function getInitialView() as Array<Views or InputDelegates>? {
        return [ new iAPSDataFieldView() ] as Array<Views or InputDelegates>;
    }

    function getServiceDelegate() {
        return [new iAPSBGServiceDelegate()];
    }


}

function getApp() as iAPSDataFieldApp {
    return Application.getApp() as iAPSDataFieldApp;
}