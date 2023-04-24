//**********************************************************************
// DESCRIPTION : Header for Watch Faces for iAPS 
// AUTHORS : 
//          Created by ivalkou - https://github.com/ivalkou 
//          Modify by Pierre Lagarde - https://github.com/avouspierre
// COPYRIGHT : (c) 2023 ivalkou / Lagarde 
//

using Toybox.Communications as Comms;
import Toybox.Background;

(:background)
class CommsRelay extends Comms.ConnectionListener {
    hidden var mCallback;

    function initialize(callback) {
        ConnectionListener.initialize();
        mCallback = callback;
    }

    function onComplete() {
        mCallback.invoke(true);
    }

    function onError() {
        mCallback.invoke(false);
    }
}