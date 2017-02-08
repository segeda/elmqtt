'use strict';

var elm = Elm.Main.embed(document.getElementById('app'));

var client = mqtt.connect('<MQTT-SERVER>');

var root_topic = 'arduino/yun/';
client.subscribe(root_topic + '#');

client.on('message', function (topic, payload) {
    if (topic === root_topic + 'humidity') {
        document.getElementById('humidity').innerText = payload + "%";
    }
    if (topic === root_topic + 'temperature') {
        document.getElementById('temperature').innerText = payload + "°C";
    }
    if (topic === root_topic + 'heatIndex') {
        document.getElementById('heatIndex').innerText = payload + "°C";
    }
});
