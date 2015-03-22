SerialPort.listDevices;

s.boot;
(
~ino = ArduinoSMS("/dev/tty.usbserial-AE015JNX", 115200);
~kbs = {Bus.control(s)}!50;
)
(
~ino.action = {
	arg msg;
	var msgs, datasplit;
	msgs = msg.asString.split($;);
	msgs.postln;
	msgs.do{
		arg it, ix;
		datasplit = it.split($:);
		//Ultrasonic Sensor to ~kbs[0]
		if(datasplit[0] == "Us1", {
			~kbs[0].set( datasplit[1].asFloat.linlin(6, 60, 0.0, 1.0) );
		});

		if(datasplit[0] == "AcX", {
			~kbs[1].set( datasplit[1].asFloat.linlin(-80.1, 80.1, 1.0, 0.0) );
		});

	};
};

SynthDef(\sensine, {
	arg pitchlo=48, pitchhi=72;
	var sig, freq;
	freq = \pitch.kr(0.5, 0.08).linlin(0.0, 1.0, pitchlo, pitchhi).midicps;
	sig = SinOsc.ar(freq);
	Out.ar(0, sig);
}).add;
)

a = Synth(\sensine);
a.map(\pitch, ~kbs[0]);

a.free;









