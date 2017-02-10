'use strict';

var elm = Elm.Main.fullscreen();

var client = mqtt.connect('<MQTT-SERVER>');

client.subscribe('arduino/yun');

client.on('message', function (topic, payload) {
    elm.ports.onMessage.send(JSON.parse(payload));
});
