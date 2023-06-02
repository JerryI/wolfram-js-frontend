
const wsconnected = new Event("wsconnected");

class FakeSocket {
    onopen = function(e) {}
    onmessage = function(e) {}
    onclose = function(e) {}

    constructor() {

    }
}

var socket = new FakeSocket();



