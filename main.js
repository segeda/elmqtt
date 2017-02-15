'use strict';

var elm = Elm.Main.fullscreen();

var client = mqtt.connect('<MQTT-SERVER>');

client.subscribe('arduino/yun');

client.on('message', function (topic, payload) {
    var data = JSON.parse(payload);
    data.created = Date.now();
    elm.ports.onMessage.send(data);
});
