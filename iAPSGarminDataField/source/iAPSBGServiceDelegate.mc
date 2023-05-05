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


    function initialize() {
        ServiceDelegate.initialize();
        //for fenix 5 if required 
        
         if (Background has :registerForPhoneAppMessageEvent) {
                // nothing to do 
        } else {
                Communications.registerForPhoneAppMessages(method(:onReceiveMessage) as Communications.PhoneMessageCallback);
                System.println("****add the registerForPhoneAppMessages done****");
        }
    }

    function onReceiveMessage(msg) {
        System.println("a message from onReceiveMessage! ");
        System.println(msg);
        Background.exit(msg.data);
    }


    function onTemporalEvent() {
        System.println("Temp event");
        Communications.transmit("status", null, new CommsRelay(method(:onTransmitComplete)));
        Background.exit(null);
    
    }

    function onPhoneAppMessage(msg) {
        System.println("****onPhoneAppMessage*****");
        System.println(msg);
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