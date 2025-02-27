# IT-AUTOFLIGHT System Controller V4.0.0
# Copyright (c) 2019 Joshua Davidson (it0uchpods)

setprop("/it-autoflight/config/tuning-mode", 0); # Not used by controller

# Initialize all used variables and property nodes
# Sim
var Velocity = {
	airspeedKt: props.globals.getNode("/velocities/airspeed-kt", 1), # Only used for gain scheduling
	groundspeedKt: props.globals.getNode("/velocities/groundspeed-kt", 1),
	groundspeedMps: 0,
	indicatedAirspeedKt: props.globals.getNode("/instrumentation/airspeed-indicator/indicated-speed-kt", 1),
	indicatedMach: props.globals.getNode("/instrumentation/airspeed-indicator/indicated-mach", 1),
	trueAirspeedKt: props.globals.getNode("/instrumentation/airspeed-indicator/true-speed-kt", 1),
	trueAirspeedKtTemp: 0,
};

var Position = {
	gearAglFtTemp: 0,
	gearAglFt: props.globals.getNode("/position/gear-agl-ft", 1),
	indicatedAltitudeFt: props.globals.getNode("/instrumentation/altimeter/indicated-altitude-ft", 1),
	indicatedAltitudeFtTemp: 0,
};

var Gear = {
	wow0: props.globals.getNode("/gear/gear[0]/wow", 1),
	wow1: props.globals.getNode("/gear/gear[1]/wow", 1),
	wow1Temp: 1,
	wow2: props.globals.getNode("/gear/gear[2]/wow", 1),
	wow2Temp: 1,
};

var Control = {
	aileron: props.globals.getNode("/controls/flight/aileron", 1),
	elevator: props.globals.getNode("/controls/flight/elevator", 1),
	rudder: props.globals.getNode("/controls/flight/rudder", 1),
};

var Radio = {
	gsDefl: [props.globals.getNode("/instrumentation/nav[0]/gs-needle-deflection-norm", 1), props.globals.getNode("/instrumentation/nav[1]/gs-needle-deflection-norm", 1)],
	gsDeflTemp: 0,
	inRange: [props.globals.getNode("/instrumentation/nav[0]/in-range", 1), props.globals.getNode("/instrumentation/nav[1]/in-range", 1)],
	inRangeTemp: 0,
	locDefl: [props.globals.getNode("/instrumentation/nav[0]/heading-needle-deflection-norm", 1), props.globals.getNode("/instrumentation/nav[1]/heading-needle-deflection-norm", 1)],
	locDeflTemp: 0,
	radioSel: 0,
	signalQuality: [props.globals.getNode("/instrumentation/nav[0]/signal-quality-norm", 1), props.globals.getNode("/instrumentation/nav[1]/signal-quality-norm", 1)],
	signalQualityTemp: 0,
};

var FPLN = {
	active: props.globals.getNode("/autopilot/route-manager/active", 1),
	activeTemp: 0,
	currentCourse: 0,
	currentWP: props.globals.getNode("/autopilot/route-manager/current-wp", 1),
	currentWPTemp: 0,
	deltaAngle: 0,
	deltaAngleRad: 0,
	distCoeff: 0,
	maxBank: 0,
	maxBankLimit: 0,
	nextCourse: 0,
	num: props.globals.getNode("/autopilot/route-manager/route/num", 1),
	numTemp: 0,
	R: 0,
	radius: 0,
	turnDist: 0,
	wp0Dist: props.globals.getNode("/autopilot/route-manager/wp/dist", 1),
	wpFlyFrom: 0,
	wpFlyTo: 0,
};

var Misc = {
	flapNorm: props.globals.getNode("/surface-positions/flap-pos-norm", 1),
};

# IT-AUTOFLIGHT
var Input = {
	alt: props.globals.initNode("/it-autoflight/input/alt", 10000, "INT"),
	ap1: props.globals.initNode("/it-autoflight/input/ap1", 0, "BOOL"),
	ap2: props.globals.initNode("/it-autoflight/input/ap2", 0, "BOOL"),
	athr: props.globals.initNode("/it-autoflight/input/athr", 0, "BOOL"),
	altDiff: 0,
	bankLimitSW: props.globals.initNode("/it-autoflight/input/bank-limit-sw", 0, "INT"),
	bankLimitSWTemp: 0,
	fd1: props.globals.initNode("/it-autoflight/input/fd1", 0, "BOOL"),
	fd2: props.globals.initNode("/it-autoflight/input/fd2", 0, "BOOL"),
	fpa: props.globals.initNode("/it-autoflight/input/fpa", 0, "DOUBLE"),
	hdg: props.globals.initNode("/it-autoflight/input/hdg", 0, "INT"),
	ias: props.globals.initNode("/it-autoflight/input/spd-kts", 250, "INT"),
	ktsMach: props.globals.initNode("/it-autoflight/input/kts-mach", 0, "BOOL"),
	lat: props.globals.initNode("/it-autoflight/input/lat", 5, "INT"),
	latTemp: 5,
	mach: props.globals.initNode("/it-autoflight/input/spd-mach", 0.5, "DOUBLE"),
	toga: props.globals.initNode("/it-autoflight/input/toga", 0, "BOOL"),
	trk: props.globals.initNode("/it-autoflight/input/trk", 0, "BOOL"),
	trueCourse: props.globals.initNode("/it-autoflight/input/true-course", 0, "BOOL"),
	vs: props.globals.initNode("/it-autoflight/input/vs", 0, "INT"),
	vert: props.globals.initNode("/it-autoflight/input/vert", 7, "INT"),
	vertTemp: 7,
};

var Internal = {
	alt: props.globals.initNode("/it-autoflight/internal/alt", 10000, "INT"),
	altCaptureActive: 0,
	altDiff: 0,
	altTemp: 0,
	altPredicted: props.globals.initNode("/it-autoflight/internal/altitude-predicted", 0, "DOUBLE"),
	bankLimit: props.globals.initNode("/it-autoflight/internal/bank-limit", 30, "INT"),
	bankLimitAuto: 30,
	captVS: 0,
	flchActive: 0,
	fpa: props.globals.initNode("/it-autoflight/internal/fpa", 0, "DOUBLE"),
	hdg: props.globals.initNode("/it-autoflight/internal/heading-deg", 0, "DOUBLE"),
	hdgPredicted: props.globals.initNode("/it-autoflight/internal/heading-predicted", 0, "DOUBLE"),
	lnavAdvanceNm: props.globals.initNode("/it-autoflight/internal/lnav-advance-nm", 0, "DOUBLE"),
	minVS: props.globals.initNode("/it-autoflight/internal/min-vs", -500, "INT"),
	maxVS: props.globals.initNode("/it-autoflight/internal/max-vs", 500, "INT"),
	trk: props.globals.initNode("/it-autoflight/internal/track-deg", 0, "DOUBLE"),
	vs: props.globals.initNode("/it-autoflight/internal/vert-speed-fpm", 0, "DOUBLE"),
	vsTemp: 0,
};

var Output = {
	ap1: props.globals.initNode("/it-autoflight/output/ap1", 0, "BOOL"),
	ap1Temp: 0,
	ap2: props.globals.initNode("/it-autoflight/output/ap2", 0, "BOOL"),
	ap2Temp: 0,
	apprArm: props.globals.initNode("/it-autoflight/output/appr-armed", 0, "BOOL"),
	athr: props.globals.initNode("/it-autoflight/output/athr", 0, "BOOL"),
	athrTemp: 0,
	fd1: props.globals.initNode("/it-autoflight/output/fd1", 0, "BOOL"),
	fd1Temp: 0,
	fd2: props.globals.initNode("/it-autoflight/output/fd2", 0, "BOOL"),
	fd2Temp: 0,
	lat: props.globals.initNode("/it-autoflight/output/lat", 5, "INT"),
	latTemp: 5,
	lnavArm: props.globals.initNode("/it-autoflight/output/lnav-armed", 0, "BOOL"),
	locArm: props.globals.initNode("/it-autoflight/output/loc-armed", 0, "BOOL"),
	thrMode: props.globals.initNode("/it-autoflight/output/thr-mode", 2, "INT"),
	vert: props.globals.initNode("/it-autoflight/output/vert", 7, "INT"),
	vertTemp: 7,
};

var Text = {
	arm: props.globals.initNode("/it-autoflight/mode/arm", " ", "STRING"),
	lat: props.globals.initNode("/it-autoflight/mode/lat", "T/O", "STRING"),
	thr: props.globals.initNode("/it-autoflight/mode/thr", " PITCH", "STRING"),
	vert: props.globals.initNode("/it-autoflight/mode/vert", "T/O CLB", "STRING"),
	vertTemp: 0,
};

var Setting = {
	autoBankMaxDeg: props.globals.getNode("/it-autoflight/settings/auto-bank-max-deg", 1),
	autolandWithoutAp: props.globals.getNode("/it-autoflight/settings/autoland-without-ap", 1),
	autolandWithoutApTemp: 0,
	disableFinal: props.globals.getNode("/it-autoflight/settings/disable-final", 1),
	latAglFt: props.globals.getNode("/it-autoflight/settings/lat-agl-ft", 1),
	landingFlap: props.globals.getNode("/it-autoflight/settings/land-flap", 1),
	reducAglFt: props.globals.getNode("/it-autoflight/settings/reduc-agl-ft", 1),
	retardAltitude: props.globals.getNode("/it-autoflight/settings/retard-ft", 1),
	retardEnable: props.globals.getNode("/it-autoflight/settings/retard-enable", 1),
	useNAV2Radio: props.globals.initNode("/it-autoflight/settings/use-nav2-radio", 0, "BOOL"),
};

var Sound = {
	apOff: props.globals.initNode("/it-autoflight/sound/apoffsound", 0, "BOOL"),
	enableApOff: 0,
};

var Gain = {
	altGain: props.globals.getNode("/it-autoflight/config/cmd/alt-gain", 1),
	hdgGain: props.globals.getNode("/it-autoflight/config/cmd/hdg", 1),
	hdgKp: props.globals.initNode("/it-autoflight/config/cmd/hdg-kp", 0, "DOUBLE"),
	hdgKpCalc: 0,
	pitchKp: props.globals.initNode("/it-autoflight/config/pitch/kp", 0, "DOUBLE"),
	pitchKpCalc: 0,
	pitchKpLow: props.globals.getNode("/it-autoflight/config/pitch/kp-low", 1),
	pitchKpLowTemp: 0,
	pitchKpHigh: props.globals.getNode("/it-autoflight/config/pitch/kp-high", 1),
	pitchKpHighTemp: 0,
	rollKp: props.globals.initNode("/it-autoflight/config/roll/kp", 0, "DOUBLE"),
	rollKpCalc: 0,
	rollKpLowTemp: 0,
	rollKpLow: props.globals.getNode("/it-autoflight/config/roll/kp-low", 1),
	rollKpHighTemp: 0,
	rollKpHigh: props.globals.getNode("/it-autoflight/config/roll/kp-high", 1),
};

var ITAF = {
	init: func() {
		Input.ktsMach.setBoolValue(0);
		Input.ap1.setBoolValue(0);
		Input.ap2.setBoolValue(0);
		Input.athr.setBoolValue(0);
		Input.fd1.setBoolValue(0);
		Input.fd2.setBoolValue(0);
		Input.hdg.setValue(360);
		Input.alt.setValue(10000);
		Input.vs.setValue(0);
		Input.fpa.setValue(0);
		Input.lat.setValue(5);
		Input.vert.setValue(7);
		Input.trk.setBoolValue(0);
		Input.trueCourse.setBoolValue(0);
		Input.toga.setBoolValue(0);
		Input.bankLimitSW.setValue(0);
		Output.ap1.setBoolValue(0);
		Output.ap2.setBoolValue(0);
		Output.athr.setBoolValue(0);
		Output.fd1.setBoolValue(0);
		Output.fd2.setBoolValue(0);
		Output.lnavArm.setBoolValue(0);
		Output.locArm.setBoolValue(0);
		Output.apprArm.setBoolValue(0);
		Output.thrMode.setValue(0);
		Output.lat.setValue(5);
		Output.vert.setValue(7);
		Setting.useNAV2Radio.setBoolValue(0);
		Internal.minVS.setValue(-500);
		Internal.maxVS.setValue(500);
		Internal.bankLimit.setValue(30);
		Internal.bankLimitAuto = 30;
		Internal.alt.setValue(10000);
		Internal.altCaptureActive = 0;
		Input.ias.setValue(250);
		Input.mach.setValue(0.5);
		Text.thr.setValue(" PITCH");
		Text.arm.setValue(" ");
		Text.lat.setValue("T/O");
		Text.vert.setValue("T/O CLB");
		loopTimer.start();
		slowLoopTimer.start();
	},
	loop: func() {
		Output.latTemp = Output.lat.getValue();
		Output.vertTemp = Output.vert.getValue();
		
		# VOR/ILS Revision
		if (Output.latTemp == 2 or Output.vertTemp == 2 or Output.vertTemp == 6) {
			me.checkRadioRevision(Output.latTemp, Output.vertTemp);
		}
		
		Gear.wow1Temp = Gear.wow1.getBoolValue();
		Gear.wow2Temp = Gear.wow2.getBoolValue();
		Output.ap1Temp = Output.ap1.getBoolValue();
		Output.ap2Temp = Output.ap2.getBoolValue();
		Output.latTemp = Output.lat.getValue();
		Output.vertTemp = Output.vert.getValue();
		Text.vertTemp = Text.vert.getValue();
		Position.gearAglFtTemp = Position.gearAglFt.getValue();
		Internal.vsTemp = Internal.vs.getValue();
		Position.indicatedAltitudeFtTemp = Position.indicatedAltitudeFt.getValue();
		Setting.autolandWithoutApTemp = Setting.autolandWithoutAp.getBoolValue();
		
		# LNAV Engagement
		if (Output.lnavArm.getBoolValue()) {
			me.checkLNAV(1);
		}
		
		# VOR/LOC or ILS/LOC Capture
		if (Output.locArm.getBoolValue()) {
			me.checkLOC(1, 0);
		}
		
		# G/S Capture
		if (Output.apprArm.getBoolValue()) {
			me.checkAPPR(1);
		}
		
		# Autoland Logic
		if (Output.latTemp == 2) {
			if (Position.gearAglFtTemp <= 150) {
				if (Output.ap1Temp or Output.ap2Temp or Setting.autolandWithoutApTemp) {
					me.setLatMode(4);
				}
			}
		}
		if (Output.vertTemp == 2) {
			if (Position.gearAglFtTemp <= 100 and Position.gearAglFtTemp >= 5) {
				if (Output.ap1Temp or Output.ap2Temp or Setting.autolandWithoutApTemp) {
					me.setVertMode(6);
				}
			}
		} else if (Output.vertTemp == 6) {
			if (!Output.ap1Temp and !Output.ap2Temp and !Setting.autolandWithoutApTemp) {
				me.activateLOC();
				me.activateGS();
			} else {
				if (Position.gearAglFtTemp <= 50 and Position.gearAglFtTemp >= 5) {
					Text.vert.setValue("FLARE");
				}
				if (Gear.wow1Temp and Gear.wow2Temp) {
					Text.lat.setValue("RLOU");
					Text.vert.setValue("ROLLOUT");
				}
			}
		}
		
		# FLCH Engagement
		if (Text.vertTemp == "T/O CLB") {
			me.checkFLCH(Setting.reducAglFt.getValue());
		}
		
		# Altitude Capture/Sync Logic
		if (Output.vertTemp != 0) {
			Internal.alt.setValue(Input.alt.getValue());
		}
		Internal.altTemp = Internal.alt.getValue();
		Internal.altDiff = Internal.altTemp - Position.indicatedAltitudeFtTemp;
		
		if (Output.vertTemp != 0 and Output.vertTemp != 2 and Output.vertTemp != 6 and Text.vertTemp != "G/A CLB") {
			Internal.captVS = math.clamp(math.round(abs(Internal.vs.getValue()) / (-1 * Gain.altGain.getValue()), 100), 50, 2500); # Capture limits
			if (abs(Internal.altDiff) <= Internal.captVS and !Gear.wow1Temp and !Gear.wow2Temp) {
				if (Internal.altTemp >= Position.indicatedAltitudeFtTemp and Internal.vsTemp >= -25) { # Don't capture if we are going the wrong way
					me.setVertMode(3);
				} else if (Internal.altTemp < Position.indicatedAltitudeFtTemp and Internal.vsTemp <= 25) { # Don't capture if we are going the wrong way
					me.setVertMode(3);
				}
			}
		}
		
		# Altitude Hold Min/Max Reset
		if (Internal.altCaptureActive) {
			if (abs(Internal.altDiff) <= 25) {
				me.resetClimbRateLim();
				Text.vert.setValue("ALT HLD");
			}
		}
		
		# Thrust Mode Selector
		if (Output.athr.getBoolValue() and Output.vertTemp != 7 and Setting.retardEnable.getBoolValue() and Position.gearAglFt.getValue() <= Setting.retardAltitude.getValue() and Misc.flapNorm.getValue() >= Setting.landingFlap.getValue() - 0.001) {
			Output.thrMode.setValue(1);
			Text.thr.setValue("RETARD");
			if (Gear.wow1Temp or Gear.wow2Temp) { # Disconnect A/THR on either main gear touch
				me.athrMaster(0);
			}
		} else if (Output.vertTemp == 4) {
			if (Internal.altTemp >= Position.indicatedAltitudeFtTemp) {
				Output.thrMode.setValue(2);
				Text.thr.setValue(" PITCH");
				if (Internal.flchActive) {
					Text.vert.setValue("SPD CLB");
				}
			} else {
				Output.thrMode.setValue(1);
				Text.thr.setValue(" PITCH");
				if (Internal.flchActive) {
					Text.vert.setValue("SPD DES");
				}
			}
		} else if (Output.vertTemp == 7) {
			Output.thrMode.setValue(2);
			Text.thr.setValue(" PITCH");
		} else {
			Output.thrMode.setValue(0);
			Text.thr.setValue("THRUST");
		}
	},
	slowLoop: func() {
		Input.bankLimitSWTemp = Input.bankLimitSW.getValue();
		Velocity.trueAirspeedKtTemp = Velocity.trueAirspeedKt.getValue();
		FPLN.activeTemp = FPLN.active.getValue();
		FPLN.currentWPTemp = FPLN.currentWP.getValue();
		FPLN.numTemp = FPLN.num.getValue();
		
		# Bank Limit
		if (Velocity.trueAirspeedKtTemp >= 420) {
			Internal.bankLimitAuto = 15;
		} else if (Velocity.trueAirspeedKtTemp >= 340) {
			Internal.bankLimitAuto = 20;
		} else {
			Internal.bankLimitAuto = 30;
		}
		math.clamp(Internal.bankLimitAuto, 15, Setting.autoBankMaxDeg.getValue()); # Limit to max degree
		
		if (Input.bankLimitSWTemp == 0) {
			Internal.bankLimit.setValue(Internal.bankLimitAuto);
		} else if (Input.bankLimitSWTemp == 1) {
			Internal.bankLimit.setValue(5);
		} else if (Input.bankLimitSWTemp == 2) {
			Internal.bankLimit.setValue(10);
		} else if (Input.bankLimitSWTemp == 3) {
			Internal.bankLimit.setValue(15);
		} else if (Input.bankLimitSWTemp == 4) {
			Internal.bankLimit.setValue(20);
		} else if (Input.bankLimitSWTemp == 5) {
			Internal.bankLimit.setValue(25);
		} else if (Input.bankLimitSWTemp == 6) {
			Internal.bankLimit.setValue(30);
		}
		
		# If in LNAV mode and route is not longer active, switch to HDG HLD
		if (Output.lat.getValue() == 1) { # Only evaulate the rest of the condition if we are in LNAV mode
			if (FPLN.num.getValue() == 0 or !FPLN.active.getBoolValue()) {
				me.setLatMode(3);
			}
		}
		
		# Waypoint Advance Logic
		if (FPLN.numTemp > 0 and FPLN.activeTemp == 1) {
			if ((FPLN.currentWPTemp + 1) < FPLN.numTemp) {
				Velocity.groundspeedMps = Velocity.groundspeedKt.getValue() * 0.5144444444444;
				FPLN.wpFlyFrom = FPLN.currentWPTemp;
				if (FPLN.wpFlyFrom < 0) {
					FPLN.wpFlyFrom = 0;
				}
				FPLN.currentCourse = getprop("/autopilot/route-manager/route/wp[" ~ FPLN.wpFlyFrom ~ "]/leg-bearing-true-deg"); # Best left at getprop
				FPLN.wpFlyTo = FPLN.currentWPTemp + 1;
				if (FPLN.wpFlyTo < 0) {
					FPLN.wpFlyTo = 0;
				}
				FPLN.nextCourse = getprop("/autopilot/route-manager/route/wp[" ~ FPLN.wpFlyTo ~ "]/leg-bearing-true-deg"); # Best left at getprop
				FPLN.maxBankLimit = Internal.bankLimit.getValue();

				FPLN.deltaAngle = math.abs(geo.normdeg180(FPLN.currentCourse - FPLN.nextCourse));
				FPLN.maxBank = FPLN.deltaAngle * 1.5;
				if (FPLN.maxBank > FPLN.maxBankLimit) {
					FPLN.maxBank = FPLN.maxBankLimit;
				}
				FPLN.radius = (Velocity.groundspeedMps * Velocity.groundspeedMps) / (9.81 * math.tan(FPLN.maxBank / 57.2957795131));
				FPLN.deltaAngleRad = (180 - FPLN.deltaAngle) / 114.5915590262;
				FPLN.R = FPLN.radius / math.sin(FPLN.deltaAngleRad);
				FPLN.distCoeff = FPLN.deltaAngle * -0.011111 + 2;
				if (FPLN.distCoeff < 1) {
					FPLN.distCoeff = 1;
				}
				FPLN.turnDist = math.cos(FPLN.deltaAngleRad) * FPLN.R * FPLN.distCoeff / 1852;
				if (Gear.wow0.getBoolValue() and FPLN.turnDist < 1) {
					FPLN.turnDist = 1;
				}
				Internal.lnavAdvanceNm.setValue(FPLN.turnDist);
				
				if (FPLN.wp0Dist.getValue() <= FPLN.turnDist) {
					FPLN.currentWP.setValue(FPLN.currentWPTemp + 1);
				}
			}
		}
		
		# Calculate Roll and Pitch Kp
		if (!Setting.disableFinal.getBoolValue()) {
			Gain.rollKpLowTemp = Gain.rollKpLow.getValue();
			Gain.rollKpHighTemp = Gain.rollKpHigh.getValue();
			Gain.pitchKpLowTemp = Gain.pitchKpLow.getValue();
			Gain.pitchKpHighTemp = Gain.pitchKpHigh.getValue();
			
			Gain.rollKpCalc = Gain.rollKpLowTemp + (Velocity.airspeedKt.getValue() - 140) * ((Gain.rollKpHighTemp - Gain.rollKpLowTemp) / (360 - 140));
			Gain.pitchKpCalc = Gain.pitchKpLowTemp + (Velocity.airspeedKt.getValue() - 140) * ((Gain.pitchKpHighTemp - Gain.pitchKpLowTemp) / (360 - 140));
			
			if (Gain.rollKpLowTemp > Gain.rollKpHighTemp) {
				Gain.rollKpCalc = math.clamp(Gain.rollKpCalc, Gain.rollKpHighTemp, Gain.rollKpLowTemp);
			} else if (Gain.rollKpLowTemp < Gain.rollKpHighTemp) {
				Gain.rollKpCalc = math.clamp(Gain.rollKpCalc, Gain.rollKpLowTemp, Gain.rollKpHighTemp);
			}
			if (Gain.pitchKpLowTemp > Gain.pitchKpHighTemp) {
				Gain.pitchKpCalc = math.clamp(Gain.pitchKpCalc, Gain.pitchKpHighTemp, Gain.pitchKpLowTemp);
			} else if (Gain.pitchKpLowTemp < Gain.pitchKpHighTemp) {
				Gain.pitchKpCalc = math.clamp(Gain.pitchKpCalc, Gain.pitchKpLowTemp, Gain.pitchKpHighTemp);
			}
			
			Gain.rollKp.setValue(Gain.rollKpCalc);
			Gain.pitchKp.setValue(Gain.pitchKpCalc);
		}
		
		# Calculate HDG Kp
		Gain.hdgKpCalc = Gain.hdgGain.getValue() + (Velocity.airspeedKt.getValue() - 140) * ((Gain.hdgGain.getValue() + 1.0 - Gain.hdgGain.getValue()) / (360 - 140));
		Gain.hdgKpCalc = math.clamp(Gain.hdgKpCalc, Gain.hdgGain.getValue(), Gain.hdgGain.getValue() + 1.0);
		
		Gain.hdgKp.setValue(Gain.hdgKpCalc);
	},
	ap1Master: func(s) {
		if (s == 1) {
			if (Output.vert.getValue() != 6 and !Gear.wow1.getBoolValue() and !Gear.wow2.getBoolValue()) {
				Control.rudder.setValue(0);
				Output.ap1.setBoolValue(1);
				Sound.enableApOff = 1;
				Sound.apOff.setBoolValue(0);
			}
		} else {
			Output.ap1.setBoolValue(0);
			me.apOffFunction();
		}
		Output.ap1Temp = Output.ap1.getBoolValue();
		if (Input.ap1.getBoolValue() != Output.ap1Temp) {
			Input.ap1.setBoolValue(Output.ap1Temp);
		}
	},
	ap2Master: func(s) {
		if (s == 1) {
			if (Output.vert.getValue() != 6 and !Gear.wow1.getBoolValue() and !Gear.wow2.getBoolValue()) {
				Control.rudder.setValue(0);
				Output.ap2.setBoolValue(1);
				Sound.enableApOff = 1;
				Sound.apOff.setBoolValue(0);
			}
		} else {
			Output.ap2.setBoolValue(0);
			me.apOffFunction();
		}
		Output.ap2Temp = Output.ap2.getBoolValue();
		if (Input.ap2.getBoolValue() != Output.ap2Temp) {
			Input.ap2.setBoolValue(Output.ap2Temp);
		}
	},
	apOffFunction: func() {
		if (!Output.ap1.getBoolValue() and !Output.ap2.getBoolValue()) { # Only do if both APs are off
			if (!Setting.disableFinal.getBoolValue()) {
				Control.aileron.setValue(0);
				Control.elevator.setValue(0);
				Control.rudder.setValue(0);
			}
			if (Sound.enableApOff) {
				Sound.apOff.setBoolValue(1);
				Sound.enableApOff = 0;
			}
		}
	},
	athrMaster: func(s) {
		if (s == 1) {
			Output.athr.setBoolValue(1);
		} else {
			Output.athr.setBoolValue(0);
		}
		Output.athrTemp = Output.athr.getBoolValue();
		if (Input.athr.getBoolValue() != Output.athrTemp) {
			Input.athr.setBoolValue(Output.athrTemp);
		}
	},
	fd1Master: func(s) {
		if (s == 1) {
			Output.fd1.setBoolValue(1);
		} else {
			Output.fd1.setBoolValue(0);
		}
		Output.fd1Temp = Output.fd1.getBoolValue();
		if (Input.fd1.getBoolValue() != Output.fd1Temp) {
			Input.fd1.setBoolValue(Output.fd1Temp);
		}
	},
	fd2Master: func(s) {
		if (s == 1) {
			Output.fd2.setBoolValue(1);
		} else {
			Output.fd2.setBoolValue(0);
		}
		Output.fd2Temp = Output.fd2.getBoolValue();
		if (Input.fd2.getBoolValue() != Output.fd2Temp) {
			Input.fd2.setBoolValue(Output.fd2Temp);
		}
	},
	setLatMode: func(n) {
		Output.vertTemp = Output.vert.getValue();
		if (n == 0) { # HDG SEL
			Output.lnavArm.setBoolValue(0);
			Output.locArm.setBoolValue(0);
			Output.apprArm.setBoolValue(0);
			Output.lat.setValue(0);
			Text.lat.setValue("HDG");
			if (Output.vertTemp == 2 or Output.vertTemp == 6) { # Also cancel G/S or FLARE if active
				me.setVertMode(1);
			} else {
				me.armTextCheck();
			}
		} else if (n == 1) { # LNAV
			me.checkLNAV(0);
		} else if (n == 2) { # VOR/LOC
			Output.lnavArm.setBoolValue(0);
			me.armTextCheck();
			me.checkLOC(0, 0);
		} else if (n == 3) { # HDG HLD
			Output.lnavArm.setBoolValue(0);
			Output.locArm.setBoolValue(0);
			Output.apprArm.setBoolValue(0);
			me.syncHDG();
			Output.lat.setValue(0);
			Text.lat.setValue("HDG");
			if (Output.vertTemp == 2 or Output.vertTemp == 6) { # Also cancel G/S or FLARE if active
				me.setVertMode(1);
			} else {
				me.armTextCheck();
			}
		} else if (n == 4) { # ALIGN
			Output.lnavArm.setBoolValue(0);
			Output.locArm.setBoolValue(0);
			Output.apprArm.setBoolValue(0);
			Output.lat.setValue(4);
			Text.lat.setValue("ALGN");
			me.armTextCheck();
		} else if (n == 5) { # T/O
			Output.lnavArm.setBoolValue(0);
			Output.locArm.setBoolValue(0);
			Output.apprArm.setBoolValue(0);
			Output.lat.setValue(5);
			Text.lat.setValue("T/O");
			me.armTextCheck();
		}
	},
	setLatArm: func(n) {
		if (n == 0) {
			Output.lnavArm.setBoolValue(0);
			me.armTextCheck();
		} else if (n == 1) {
			if (FPLN.num.getValue() > 0 and FPLN.active.getBoolValue()) {
				Output.lnavArm.setBoolValue(1);
				me.armTextCheck();
			}
		} else if (n == 3) {
			me.syncHDG();
			Output.lnavArm.setBoolValue(0);
			me.armTextCheck();
		} 
	},
	setVertMode: func(n) {
		Input.altDiff = Input.alt.getValue() - Position.indicatedAltitudeFt.getValue();
		if (n == 0) { # ALT HLD
			Internal.flchActive = 0;
			Internal.altCaptureActive = 0;
			Output.apprArm.setBoolValue(0);
			Output.vert.setValue(0);
			me.resetClimbRateLim();
			Text.vert.setValue("ALT HLD");
			me.syncALT();
			me.armTextCheck();
		} else if (n == 1) { # V/S
			if (abs(Input.altDiff) >= 25) {
				Internal.flchActive = 0;
				Internal.altCaptureActive = 0;
				Output.apprArm.setBoolValue(0);
				Output.vert.setValue(1);
				Text.vert.setValue("V/S");
				me.syncVS();
				me.armTextCheck();
			} else {
				Output.apprArm.setBoolValue(0);
				me.armTextCheck();
			}
		} else if (n == 2) { # G/S
			me.checkLOC(0, 1);
			me.checkAPPR(0);
		} else if (n == 3) { # ALT CAP
			Internal.flchActive = 0;
			Output.vert.setValue(0);
			me.setClimbRateLim();
			Internal.altCaptureActive = 1;
			Text.vert.setValue("ALT CAP");
		} else if (n == 4) { # FLCH
			Output.apprArm.setBoolValue(0);
			Output.vert.setValue(1);
			Internal.alt.setValue(Input.alt.getValue());
			Internal.altDiff = Internal.alt.getValue() - Position.indicatedAltitudeFt.getValue();
			if (abs(Internal.altDiff) >= 250) { # SPD CLB or SPD DES
				Internal.altCaptureActive = 0;
				Output.vert.setValue(4);
				Internal.flchActive = 1;
			} else { # ALT CAP
				Internal.flchActive = 0;
				Internal.alt.setValue(Input.alt.getValue());
				Internal.altCaptureActive = 1;
				Output.vert.setValue(0);
				Text.vert.setValue("ALT CAP");
			}
			me.armTextCheck();
		} else if (n == 5) { # FPA
			if (abs(Input.altDiff) >= 25) {
				Internal.flchActive = 0;
				Internal.altCaptureActive = 0;
				Output.apprArm.setBoolValue(0);
				Output.vert.setValue(5);
				Text.vert.setValue("FPA");
				me.syncFPA();
				me.armTextCheck();
			} else {
				Output.apprArm.setBoolValue(0);
				me.armTextCheck();
			}
		} else if (n == 6) { # FLARE/ROLLOUT
			Internal.flchActive = 0;
			Internal.altCaptureActive = 0;
			Output.apprArm.setBoolValue(0);
			Output.vert.setValue(6);
			Text.vert.setValue("G/S");
			me.armTextCheck();
		} else if (n == 7) { # T/O CLB or G/A CLB, text is set by TOGA selector
			Internal.flchActive = 0;
			Internal.altCaptureActive = 0;
			Output.apprArm.setBoolValue(0);
			Output.vert.setValue(7);
			me.armTextCheck();
		}
	},
	activateLNAV: func() {
		if (Output.lat.getValue() != 1) {
			Output.lnavArm.setBoolValue(0);
			Output.locArm.setBoolValue(0);
			Output.apprArm.setBoolValue(0);
			Output.lat.setValue(1);
			Text.lat.setValue("LNAV");
			if (Output.vertTemp == 2 or Output.vertTemp == 6) { # Also cancel G/S or FLARE if active
				me.setVertMode(1);
			} else {
				me.armTextCheck();
			}
		}
	},
	activateLOC: func() {
		if (Output.lat.getValue() != 2) {
			Output.lnavArm.setBoolValue(0);
			Output.locArm.setBoolValue(0);
			Output.lat.setValue(2);
			Text.lat.setValue("LOC");
			me.armTextCheck();
		}
	},
	activateGS: func() {
		if (Output.vert.getValue() != 2) {
			Internal.flchActive = 0;
			Internal.altCaptureActive = 0;
			Output.apprArm.setBoolValue(0);
			Output.vert.setValue(2);
			Text.vert.setValue("G/S");
			me.armTextCheck();
		}
	},
	checkLNAV: func(t) {
		if (FPLN.num.getValue() > 0 and FPLN.active.getBoolValue() and Position.gearAglFt.getValue() >= Setting.latAglFt.getValue()) {
			me.activateLNAV();
		} else if (Output.lat.getValue() != 1 and t != 1) {
			Output.lnavArm.setBoolValue(1);
			me.armTextCheck();
		}
	},
	checkFLCH: func(a) {
		if (Position.gearAglFt.getValue() >= a and a != 0) {
			me.setVertMode(4);
		}
	},
	checkLOC: func(t, a) {
		Radio.radioSel = Setting.useNAV2Radio.getBoolValue();
		if (Radio.inRange[Radio.radioSel].getBoolValue()) { #  # Only evaulate the rest of the condition unless we are in range
			Radio.locDeflTemp = Radio.locDefl[Radio.radioSel].getValue();
			Radio.signalQualityTemp = Radio.signalQuality[Radio.radioSel].getValue();
			if (abs(Radio.locDeflTemp) <= 0.95 and Radio.locDeflTemp != 0 and Radio.signalQualityTemp >= 0.99) {
				me.activateLOC();
			} else if (t != 1) { # Do not do this if loop calls it
				if (Output.lat.getValue() != 2) {
					Output.lnavArm.setBoolValue(0);
					Output.locArm.setBoolValue(1);
					if (a != 1) { # Don't call this if arming with G/S
						me.armTextCheck();
					}
				}
			}
		} else { # Prevent bad behavior due to FG not updating it when not in range
			Radio.signalQuality[Radio.radioSel].setValue(0);
		}
	},
	checkAPPR: func(t) {
		Radio.radioSel = Setting.useNAV2Radio.getBoolValue();
		if (Radio.inRange[Radio.radioSel].getBoolValue()) { #  # Only evaulate the rest of the condition unless we are in range
			Radio.gsDeflTemp = Radio.gsDefl[Radio.radioSel].getValue();
			if (abs(Radio.gsDeflTemp) <= 0.2 and Radio.gsDeflTemp != 0 and Output.lat.getValue()  == 2) { # Only capture if LOC is active
				me.activateGS();
			} else if (t != 1) { # Do not do this if loop calls it
				if (Output.vert.getValue() != 2) {
					Output.apprArm.setBoolValue(1);
				}
				me.armTextCheck();
			}
		} else { # Prevent bad behavior due to FG not updating it when not in range
			Radio.signalQuality[Radio.radioSel].setValue(0);
		}
	},
	checkRadioRevision: func(l, v) { # Revert mode if signal lost
		Radio.radioSel = Setting.useNAV2Radio.getBoolValue();
		Radio.inRangeTemp = Radio.inRange[Radio.radioSel].getBoolValue();
		if (!Radio.inRangeTemp) {
			if (l == 4 or v == 6) {
				me.ap1Master(0);
				me.ap2Master(0);
				me.setLatMode(3);
				me.setVertMode(1);
			} else {
				me.setLatMode(3); # Also cancels G/S if active
			}
		}
	},
	setClimbRateLim: func() {
		Internal.vsTemp = Internal.vs.getValue();
		if (Internal.alt.getValue() >= Position.indicatedAltitudeFt.getValue()) {
			Internal.maxVS.setValue(math.round(Internal.vsTemp));
			Internal.minVS.setValue(-500);
		} else {
			Internal.maxVS.setValue(500);
			Internal.minVS.setValue(math.round(Internal.vsTemp));
		}
	},
	resetClimbRateLim: func() {
		Internal.minVS.setValue(-500);
		Internal.maxVS.setValue(500);
	},
	takeoffGoAround: func() {
		Output.vertTemp = Output.vert.getValue();
		if ((Output.vertTemp == 2 or Output.vertTemp == 6) and Velocity.indicatedAirspeedKt.getValue() >= 80) {
			if (Gear.wow1.getBoolValue() or Gear.wow2.getBoolValue()) {
				me.ap1Master(0);
				me.ap2Master(0);
			}
			me.setLatMode(3);
			me.setVertMode(7);
			Text.vert.setValue("G/A CLB");
			Input.ktsMach.setBoolValue(0);
			me.syncIAS();
		} else if (Gear.wow1Temp or Gear.wow2Temp) {
			me.athrMaster(1);
			me.setLatMode(5);
			me.setVertMode(7);
			Text.vert.setValue("T/O CLB");
		}
	},
	armTextCheck: func() {
		if (Output.apprArm.getBoolValue()) {
			Text.arm.setValue("ILS");
		} else if (Output.locArm.getBoolValue()) {
			Text.arm.setValue("LOC");
		} else if (Output.lnavArm.getBoolValue()) {
			Text.arm.setValue("LNV");
		} else {
			Text.arm.setValue(" ");
		}
	},
	syncIAS: func() {
		Input.ias.setValue(math.clamp(math.round(Velocity.indicatedAirspeedKt.getValue()), 100, 350));
	},
	syncMach: func() {
		Input.mach.setValue(math.clamp(math.round(Velocity.indicatedMach.getValue(), 0.001), 0.5, 0.9));
	},
	syncHDG: func() {
		Input.hdg.setValue(math.round(Internal.hdgPredicted.getValue())); # Switches to track automatically
	},
	syncALT: func() {
		Input.alt.setValue(math.clamp(math.round(Internal.altPredicted.getValue(), 100), 0, 50000));
		Internal.alt.setValue(math.clamp(math.round(Internal.altPredicted.getValue(), 100), 0, 50000));
	},
	syncVS: func() {
		Input.vs.setValue(math.clamp(math.round(Internal.vs.getValue(), 100), -6000, 6000));
	},
	syncFPA: func() {
		Input.fpa.setValue(math.clamp(math.round(Internal.fpa.getValue(), 0.1), -9.9, 9.9));
	},
};

setlistener("/it-autoflight/input/ap1", func {
	Input.ap1Temp = Input.ap1.getBoolValue();
	if (Input.ap1Temp != Output.ap1.getBoolValue()) {
		ITAF.ap1Master(Input.ap1Temp);
	}
});

setlistener("/it-autoflight/input/ap2", func {
	Input.ap2Temp = Input.ap2.getBoolValue();
	if (Input.ap2Temp != Output.ap2.getBoolValue()) {
		ITAF.ap2Master(Input.ap2Temp);
	}
});

setlistener("/it-autoflight/input/athr", func {
	Input.athrTemp = Input.athr.getBoolValue();
	if (Input.athrTemp != Output.athr.getBoolValue()) {
		ITAF.athrMaster(Input.athrTemp);
	}
});

setlistener("/it-autoflight/input/fd1", func {
	Input.fd1Temp = Input.fd1.getBoolValue();
	if (Input.fd1Temp != Output.fd1.getBoolValue()) {
		ITAF.fd1Master(Input.fd1Temp);
	}
});

setlistener("/it-autoflight/input/fd2", func {
	Input.fd2Temp = Input.fd2.getBoolValue();
	if (Input.fd2Temp != Output.fd2.getBoolValue()) {
		ITAF.fd2Master(Input.fd2Temp);
	}
});

setlistener("/it-autoflight/input/kts-mach", func {
	if (Input.ktsMach.getBoolValue()) {
		ITAF.syncMach();
	} else {
		ITAF.syncIAS();
	}
}, 0, 0);

setlistener("/it-autoflight/input/toga", func {
	if (Input.toga.getBoolValue()) {
		ITAF.takeoffGoAround();
		Input.toga.setBoolValue(0);
	}
});

setlistener("/it-autoflight/input/lat", func {
	Input.latTemp = Input.lat.getValue();
	if (!Gear.wow1.getBoolValue() and !Gear.wow2.getBoolValue()) {
		ITAF.setLatMode(Input.latTemp);
	} else {
		ITAF.setLatArm(Input.latTemp);
	}
});

setlistener("/it-autoflight/input/vert", func {
	if (!Gear.wow1.getBoolValue() and !Gear.wow2.getBoolValue()) {
		ITAF.setVertMode(Input.vert.getValue());
	}
});

setlistener("/sim/signals/fdm-initialized", func {
	ITAF.init();
});

# For Canvas Nav Display.
setlistener("/it-autoflight/input/hdg", func {
	setprop("/autopilot/settings/heading-bug-deg", getprop("/it-autoflight/input/hdg"));
});

setlistener("/it-autoflight/internal/alt", func {
	setprop("/autopilot/settings/target-altitude-ft", getprop("/it-autoflight/internal/alt"));
});

var loopTimer = maketimer(0.1, ITAF, ITAF.loop);
var slowLoopTimer = maketimer(1, ITAF, ITAF.slowLoop);
