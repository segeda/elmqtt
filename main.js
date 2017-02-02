'use strict';

var elm = Elm.Main.embed(document.getElementById('app'));

var client = mqtt.connect('<MQTT-SERVER>');
client.subscribe('arduino/yun/time');
client.subscribe('arduino/yun/humidity');
client.subscribe('arduino/yun/temperature');
client.subscribe('arduino/yun/heatIndex');

client.on('message', function (topic, payload) {
    if (topic === "arduino/yun/time") {
        var epoch = new Date(payload * 1000);
        document.getElementById('time').innerText = epoch.toLocaleString();
    }
    if (topic === "arduino/yun/humidity") {
        document.getElementById('humidity').innerText = payload + "%";
    }
    if (topic === "arduino/yun/temperature") {
        document.getElementById('temperature').innerText = payload + "°C";
    }
    if (topic === "arduino/yun/heatIndex") {
        document.getElementById('heatIndex').innerText = payload + "°C";
    }
});