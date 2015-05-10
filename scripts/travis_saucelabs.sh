#!/bin/bash

declare -a capabilities=(
  "export SELENIUM_BROWSER_CAPABILITIES='{\"browserName\":\"firefox\", \"platform\":\"Linux\"}'"
  "export SELENIUM_BROWSER_CAPABILITIES='{\"browserName\":\"firefox\", \"platform\":\"OS X 10.10\"}'"
  "export SELENIUM_BROWSER_CAPABILITIES='{\"browserName\":\"firefox\", \"version\":\"3.0\", \"platform\":\"Windows 8.1\"}'"
  "export SELENIUM_BROWSER_CAPABILITIES='{\"browserName\":\"firefox\", \"version\":\"3.5\", \"platform\":\"Windows 8.1\"}'"
  "export SELENIUM_BROWSER_CAPABILITIES='{\"browserName\":\"firefox\", \"version\":\"3.6\", \"platform\":\"Windows 8.1\"}'"
  "export SELENIUM_BROWSER_CAPABILITIES='{\"browserName\":\"firefox\", \"version\":\"4.0\", \"platform\":\"Windows 8.1\"}'"
  "export SELENIUM_BROWSER_CAPABILITIES='{\"browserName\":\"firefox\", \"version\":\"5.0\", \"platform\":\"Windows 8.1\"}'"
  "export SELENIUM_BROWSER_CAPABILITIES='{\"browserName\":\"firefox\", \"version\":\"6.0\", \"platform\":\"Windows 8.1\"}'"
  "export SELENIUM_BROWSER_CAPABILITIES='{\"browserName\":\"firefox\", \"version\":\"7.0\", \"platform\":\"Windows 8.1\"}'"
  "export SELENIUM_BROWSER_CAPABILITIES='{\"browserName\":\"firefox\", \"version\":\"8.0\", \"platform\":\"Windows 8.1\"}'"
  "export SELENIUM_BROWSER_CAPABILITIES='{\"browserName\":\"firefox\", \"version\":\"14.0\", \"platform\":\"Windows 8.1\"}'"
  "export SELENIUM_BROWSER_CAPABILITIES='{\"browserName\":\"firefox\", \"version\":\"15.0\", \"platform\":\"Windows 8.1\"}'"
  "export SELENIUM_BROWSER_CAPABILITIES='{\"browserName\":\"firefox\", \"version\":\"16.0\", \"platform\":\"Windows 8.1\"}'"
  "export SELENIUM_BROWSER_CAPABILITIES='{\"browserName\":\"firefox\", \"version\":\"17.0\", \"platform\":\"Windows 8.1\"}'"
  "export SELENIUM_BROWSER_CAPABILITIES='{\"browserName\":\"firefox\", \"version\":\"18.0\", \"platform\":\"Windows 8.1\"}'"
  "export SELENIUM_BROWSER_CAPABILITIES='{\"browserName\":\"firefox\", \"version\":\"19.0\", \"platform\":\"Windows 8.1\"}'"
  "export SELENIUM_BROWSER_CAPABILITIES='{\"browserName\":\"firefox\", \"version\":\"20.0\", \"platform\":\"Windows 8.1\"}'"
  "export SELENIUM_BROWSER_CAPABILITIES='{\"browserName\":\"firefox\", \"version\":\"21.0b1\", \"platform\":\"Windows 8.1\"}'"
  "export SELENIUM_BROWSER_CAPABILITIES='{\"browserName\":\"firefox\", \"version\":\"27.0\", \"platform\":\"Windows 8.1\"}'"
  "export SELENIUM_BROWSER_CAPABILITIES='{\"browserName\":\"firefox\", \"version\":\"28.0\", \"platform\":\"Windows 8.1\"}'"
  "export SELENIUM_BROWSER_CAPABILITIES='{\"browserName\":\"firefox\", \"version\":\"29.0\", \"platform\":\"Windows 8.1\"}'"
  "export SELENIUM_BROWSER_CAPABILITIES='{\"browserName\":\"firefox\", \"version\":\"30.0\", \"platform\":\"Windows 8.1\"}'"
  "export SELENIUM_BROWSER_CAPABILITIES='{\"browserName\":\"firefox\", \"version\":\"31.0\", \"platform\":\"Windows 8.1\"}'"
  "export SELENIUM_BROWSER_CAPABILITIES='{\"browserName\":\"firefox\", \"version\":\"32.0\", \"platform\":\"Windows 8.1\"}'"
  "export SELENIUM_BROWSER_CAPABILITIES='{\"browserName\":\"firefox\", \"version\":\"33.0\", \"platform\":\"Windows 8.1\"}'"
  "export SELENIUM_BROWSER_CAPABILITIES='{\"browserName\":\"firefox\", \"version\":\"34.0\", \"platform\":\"Windows 8.1\"}'"
  "export SELENIUM_BROWSER_CAPABILITIES='{\"browserName\":\"chrome\", \"platform\":\"Linux\"}'"
  "export SELENIUM_BROWSER_CAPABILITIES='{\"browserName\":\"chrome\", \"platform\":\"OS X 10.10\"}'"
  "export SELENIUM_BROWSER_CAPABILITIES='{\"browserName\":\"chrome\", \"version\":\"26.0\", \"platform\":\"Windows 8.1\"}'"
  "export SELENIUM_BROWSER_CAPABILITIES='{\"browserName\":\"chrome\", \"version\":\"27.0\", \"platform\":\"Windows 8.1\"}'"
  "export SELENIUM_BROWSER_CAPABILITIES='{\"browserName\":\"chrome\", \"version\":\"28.0\", \"platform\":\"Windows 8.1\"}'"
  "export SELENIUM_BROWSER_CAPABILITIES='{\"browserName\":\"chrome\", \"version\":\"29.0\", \"platform\":\"Windows 8.1\"}'"
  "export SELENIUM_BROWSER_CAPABILITIES='{\"browserName\":\"chrome\", \"version\":\"30.0\", \"platform\":\"Windows 8.1\"}'"
  "export SELENIUM_BROWSER_CAPABILITIES='{\"browserName\":\"chrome\", \"version\":\"31.0\", \"platform\":\"Windows 8.1\"}'"
  "export SELENIUM_BROWSER_CAPABILITIES='{\"browserName\":\"chrome\", \"version\":\"32.0\", \"platform\":\"Windows 8.1\"}'"
  "export SELENIUM_BROWSER_CAPABILITIES='{\"browserName\":\"chrome\", \"version\":\"33.0\", \"platform\":\"Windows 8.1\"}'"
  "export SELENIUM_BROWSER_CAPABILITIES='{\"browserName\":\"chrome\", \"version\":\"34.0\", \"platform\":\"Windows 8.1\"}'"
  "export SELENIUM_BROWSER_CAPABILITIES='{\"browserName\":\"chrome\", \"version\":\"35.0\", \"platform\":\"Windows 8.1\"}'"
  "export SELENIUM_BROWSER_CAPABILITIES='{\"browserName\":\"chrome\", \"version\":\"36.0\", \"platform\":\"Windows 8.1\"}'"
  "export SELENIUM_BROWSER_CAPABILITIES='{\"browserName\":\"chrome\", \"version\":\"37.0\", \"platform\":\"Windows 8.1\"}'"
  "export SELENIUM_BROWSER_CAPABILITIES='{\"browserName\":\"chrome\", \"version\":\"38.0\", \"platform\":\"Windows 8.1\"}'"
  "export SELENIUM_BROWSER_CAPABILITIES='{\"browserName\":\"chrome\", \"version\":\"39.0\", \"platform\":\"Windows 8.1\"}'"
  "export SELENIUM_BROWSER_CAPABILITIES='{\"browserName\":\"chrome\", \"version\":\"40.0\", \"platform\":\"Windows 8.1\"}'"
  "export SELENIUM_BROWSER_CAPABILITIES='{\"browserName\":\"chrome\", \"version\":\"41.0\", \"platform\":\"Windows 8.1\"}'"
  "export SELENIUM_BROWSER_CAPABILITIES='{\"browserName\":\"chrome\", \"version\":\"42.0\", \"platform\":\"Windows 8.1\"}'"
  "export SELENIUM_BROWSER_CAPABILITIES='{\"browserName\":\"chrome\", \"version\":\"beta\", \"platform\":\"Windows 8.1\"}'"
  "export SELENIUM_BROWSER_CAPABILITIES='{\"browserName\":\"chrome\", \"version\":\"dev\", \"platform\":\"Windows 8.1\"}'"
  "export SELENIUM_BROWSER_CAPABILITIES='{\"browserName\":\"chrome\", \"version\":\"26.0\", \"platform\":\"Windows 8.1\"}'"
  "export SELENIUM_BROWSER_CAPABILITIES='{\"browserName\":\"opera\", \"platform\":\"Linux\"}'"
  "export SELENIUM_BROWSER_CAPABILITIES='{\"browserName\":\"opera\", \"version\":\"11.64\", \"platform\":\"Windows 7\"}'"
  "export SELENIUM_BROWSER_CAPABILITIES='{\"browserName\":\"opera\", \"version\":\"12.12\", \"platform\":\"Windows 7\"}'"
  "export SELENIUM_BROWSER_CAPABILITIES='{\"browserName\":\"opera\", \"platform\":\"Windows 7\"}'"
  "export SELENIUM_BROWSER_CAPABILITIES='{\"browserName\":\"safari\", \"platform\":\"OS X 10.10\"}'"
  "export SELENIUM_BROWSER_CAPABILITIES='{\"browserName\":\"safari\", \"platform\":\"OS X 10.9\"}'"
  "export SELENIUM_BROWSER_CAPABILITIES='{\"browserName\":\"safari\", \"platform\":\"OS X 10.8\"}'"
  "export SELENIUM_BROWSER_CAPABILITIES='{\"browserName\":\"safari\", \"platform\":\"OS X 10.6\"}'"
  "export SELENIUM_BROWSER_CAPABILITIES='{\"browserName\":\"safari\", \"platform\":\"Windows 7\"}'"
  "export SELENIUM_BROWSER_CAPABILITIES='{\"browserName\":\"iphone\", \"deviceName\":\"iPhone Simulator\", \"device-orientation\":\"portrait\"}'"
  "export SELENIUM_BROWSER_CAPABILITIES='{\"browserName\":\"iphone\", \"deviceName\":\"iPad Simulator\", \"device-orientation\":\"portrait\"}'"
  "export SELENIUM_BROWSER_CAPABILITIES='{\"browserName\":\"android\", \"version\":\"4.0\", \"deviceName\":\"Android Emulator\", \"platform\":\"Linux\"}'"
  "export SELENIUM_BROWSER_CAPABILITIES='{\"browserName\":\"android\", \"version\":\"4.1\", \"deviceName\":\"Android Emulator\", \"platform\":\"Linux\"}'"
  "export SELENIUM_BROWSER_CAPABILITIES='{\"browserName\":\"android\", \"version\":\"4.2\", \"deviceName\":\"Android Emulator\", \"platform\":\"Linux\"}'"
  "export SELENIUM_BROWSER_CAPABILITIES='{\"browserName\":\"android\", \"version\":\"4.3\", \"deviceName\":\"Android Emulator\", \"platform\":\"Linux\"}'"
  "export SELENIUM_BROWSER_CAPABILITIES='{\"browserName\":\"android\", \"version\":\"4.4\", \"deviceName\":\"Android Emulator\", \"platform\":\"Linux\"}'"
  "export SELENIUM_BROWSER_CAPABILITIES='{\"browserName\":\"android\", \"version\":\"5.1\", \"deviceName\":\"Android Emulator\", \"platform\":\"Linux\"}'"
  "export SELENIUM_BROWSER_CAPABILITIES='{\"browserName\":\"internet explorer\", \"version\":\"7\", \"platform\":\"Windows XP\"}'"
  "export SELENIUM_BROWSER_CAPABILITIES='{\"browserName\":\"internet explorer\", \"version\":\"8\", \"platform\":\"Windows 7\"}'"
  "export SELENIUM_BROWSER_CAPABILITIES='{\"browserName\":\"internet explorer\", \"version\":\"9\", \"platform\":\"Windows 7\"}'"
  "export SELENIUM_BROWSER_CAPABILITIES='{\"browserName\":\"internet explorer\", \"version\":\"10\", \"platform\":\"Windows 8\"}'"
  "export SELENIUM_BROWSER_CAPABILITIES='{\"browserName\":\"internet explorer\", \"version\":\"11\", \"platform\":\"Windows 8.1\"}'"
  "export SELENIUM_BROWSER_CAPABILITIES='{\"browserName\":\"internet explorer\", \"platform\":\"Windows 8.1\"}'"
  "export SELENIUM_BROWSER_CAPABILITIES='{\"browserName\":\"internet explorer\", \"platform\":\"Windows 8.1\"}'"
)

## now loop through the above array
for i in "${capabilities[@]}"
do
   eval $i
   $TRAVIS_BUILD_DIR/backend/bin/globaleaks -z travis -c -k9
   sleep 5
   grunt protractor:saucelabs
done
