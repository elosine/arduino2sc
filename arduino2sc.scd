SerialPort.listDevices;

s.boot;
(
~ino = ArduinoSMS("/dev/tty.usbserial-AE015LFK", 9600);
~kbs = {Bus.control(s)}!50;
)
(
var shaketog1=0;
~ino.action = {
	arg msg;
	var msgs, datasplit, gyz;
	msgs = msg.asString.split($;);
	msgs.do{
		arg it, ix;
		datasplit = it.split($:);

		//Ultrasonic Sensor to ~kbs[0]
		if(datasplit[0] == "Us1", {
			~kbs[0].set( datasplit[1].asFloat.linlin(6, 60, 0.0, 1.0) );
		});

		//Capacitive Switch to ~kbs[1]
		if(datasplit[0] == "sw1", {
			~kbs[1].set(datasplit[1].asFloat);
		});

		//Potentiometer to ~kbs[2]
		if(datasplit[0] == "Po1", {
			~kbs[2].set(datasplit[1].asFloat.linlin(0.0, 1023.0, 0.0, 1.0));
		});

		//AccelY to ~kbs[3]
		if(datasplit[0] == "AcY", {
			~kbs[3].set(datasplit[1].asFloat.linlin(-80.0, 80.0, 0.0, 1.0));
		});

		//Gyroscope Z to ~kbs[4]
		if(datasplit[0] == "GyZ", {
			gyz = ~kbs[4].getSynchronous;
			gyz = (datasplit[1].asFloat.linlin(-90.0, 90.0, -0.01, 0.01) + gyz).clip(0.0, 1.0);
			~kbs[4].setSynchronous(gyz);
		});

		//AccelX_Velocity Toggle to ~kbs[5]
		if(datasplit[0] == "AcXv", {
			if(datasplit[1].asFloat > 80.0, { shaketog1 = (shaketog1+1)%2; shaketog1.postln;~kbs[5].set(shaketog1.asInteger); });

		});

	};
};

SynthDef(\sensine, {
	arg pitchlo=48, pitchhi=72, gate=1, ratelo=0.0, ratehi=5;
	var sig, freq, env, vib;
	vib = SinOsc.kr( \rate.kr(0, 0).linlin(0.0, 1.0, ratelo, ratehi) );
	env = EnvGen.ar(Env.asr(), gate);
	freq = ( \pitch.kr(0.5, 0.08).linlin(0.0, 1.0, pitchlo, pitchhi) + vib ).midicps;
	sig = SinOsc.ar(freq);
	Out.ar(0, sig*env);
}).add;
)

a = Synth(\sensine);
a.map(\pitch, ~kbs[0]);
a.map(\gate, ~kbs[1]);
a.map(\pitch, ~kbs[2]);
a.map(\pitch, ~kbs[3]);
a.map(\rate, ~kbs[4]);
a.map(\gate, ~kbs[5]);

a.free;


~kbs[3].getSynchronous;








