SerialPort.listDevices
s.boot;
(
~ino = ArduinoSMS("/dev/tty.usbserial-AE015LG5", 9600);
~kbs = {Bus.control(s)}!50;
)
(
~ino.action = {
	arg msg;
	var msgs, datasplit, data;
	msgs = msg.asString.split($;);
	data = Array.newClear(msgs.size);
	msgs.do{
		arg it, ix;
		datasplit = it.split($:);
		if(datasplit[0] == "AcX", {
			~kbs[0].set( datasplit[1].asFloat.linlin(-80.1, 80.1, 1.0, 0.0) );

		});
	};
};

SynthDef(\acl, {
	Out.ar(0, SinOsc.ar( \freq.kr(0.5, 0.05).linexp(0.0, 1.0, 100, 1000).poll ) );
}).add;
)
a = Synth(\acl);
a.free;

~kbs[0].get;
a.map(\freq, ~kbs[0]);









