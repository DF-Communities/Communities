
app.service('deviceService', function DeviceService($rootScope, $window, $log)
{
  'use strict';

    var userAgent = $window.navigator.userAgent;
    var DEVICE_PATTERN = /iPod|iPhone|iPad|Android|BlackBerry|BB10|Palm|CriOS|IEMobile|Windows Phone OS|webOS|Symbian|silk|Kindle|Opera Mini|mobile/i;
    var TABLET_PATTERN = /ip(a|ro)d|silk|xoom|playbook|tablet|kindle|Nexus 7|GT-P10|SC-01C|SHW-M180S|SM-T320|SGH-T849|SCH-I800|SHW-M180L|SPH-P100|SGH-I987|zt180|HTC( Flyer|_Flyer)|Sprint ATP51|ViewPad7|pandigital(sprnova|nova)|Ideos S7|Dell Streak 7|Advent Vega|A101IT|A70BHT|MID7015|Next2|nook|FOLIO|MB511.*RUTEM|Mac OS.*Silk/i;

    this.isDevice = function() {
        if (angular.isString(userAgent)) {
            return DEVICE_PATTERN.test(userAgent) || TABLET_PATTERN.test(userAgent);
        }
        return false;
    };
    
    this.isTablet = function() {
        if (angular.isString(userAgent)) {
            return TABLET_PATTERN.test(userAgent);
        }
        return false;
    };
    
    this.getDevicePlatform = function() {
        if (angular.isString(userAgent)) {
            var matched = userAgent.match(/iPod|iPhone|iPad|Android|BlackBerry|Windows Phone OS|webOS|Symbian|mobile/g);
            if (matched && matched.length > 0) {
                return matched[0];
            }
        }
    }
    
    this.isMobile = function() {
        if (DEVICE_PATTERN.test(userAgent) || TABLET_PATTERN.test(userAgent)) {
            if (getDevicePlatform(userAgent) === "Android") {
                return /Version\/\d.\d/i.test(userAgent);
            }
            return /(iPhone|iPod|iPad).*AppleWebKit(?!.*Safari)|PLAYSTATION|iPadApp/i.test(userAgent);
        }
        return false;
    };
    
    this.isSafariViewController = function() {
        if (angular.isString(userAgent)) {
            var ios = /iphone|ipod|ipad/i.test(userAgent);
            return ios && $window.indexedDB && isApp();
        } else {
            return false;
        }
    };
    
});

