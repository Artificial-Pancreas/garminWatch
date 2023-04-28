//**********************************************************************
// DESCRIPTION : service delegation of iAPS connexion 
// AUTHORS : 
//          Created by ivalkou - https://github.com/ivalkou 
//          Modify by Pierre Lagarde - https://github.com/avouspierre
// COPYRIGHT : (c) 2023 ivalkou / Lagarde 
//

import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Background;
import Toybox.System;
import Toybox.Communications;

(:background)
class iAPSBGServiceDelegate extends System.ServiceDelegate {
    var phoneCallback;

    function initialize() {
        ServiceDelegate.initialize();
    }

    function onReceiveMessage(msg)
	{
        Background.exit(msg.data);
	}

    function onTemporalEvent() {
        System.println("Temp event");
        // call the callback if data is available
        Communications.transmit("status", null, new CommsRelay(method(:onTransmitComplete)));
        //for fenix 5
        //phoneCallback = method(:onReceiveMessage) as Communications.PhoneMessageCallback;
        //Communications.registerForPhoneAppMessages(phoneCallback);
        Background.exit(null);
    
    }

    function onPhoneAppMessage(msg) {
        System.println(msg.data);
        Application.Storage.setValue("status", msg.data as Dictionary);
        Background.exit(null);
    }

    function onTransmitComplete(isSuccess) {
        if (isSuccess) {
            System.println("Listener onComplete");
        } else {
            System.println("Listener onError");
        }
        Background.exit(isSuccess);
    }
}