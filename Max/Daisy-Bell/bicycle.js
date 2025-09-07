inlets = 2; // 0=생성/초기화 bang, 1=회전 각도 (0~360)
outlets = 0;

var numBangs = 12;
var radius = 80;

// 회전 바퀴 중심
var centerX1 = 200;
var centerY1 = 300;
var centerX2 = 555;
var centerY2 = 300;

var bangObjs1 = [];
var initialAngles1 = [];
var bangObjs2 = [];
var initialAngles2 = [];

// 고정 bang 좌표 (JSON에서 가져온 값 + 새로 추가된 4개)
var fixedBangs = [
    [387.9121068716049, 273.6263870000839],
    [415.9340862631798, 334.0659503936768],
    [180.0, 120.0],
    [270.0, 135.0],
    [450.0, 179.0],
    [405.0, 285.0],
    [225.0, 134.0],
    [555.0, 300.0],
    [195.0, 300.0]
];
var fixedBangObjs = [];

// 고정 bang 연결 정보 ([sourceIndex, destIndex])
var fixedConnections = [
    [5, 0],
    [5, 1],
    [3, 6],
    [2, 6],
    [6, 4],
    [4, 7],
    [4, 5],
    [6, 5],
    [5, 7],
    [6, 8]
];

// 생성
function bang() {
    if (inlet === 0) makeWheel();
}

// 원형 bang 생성 + 고정 bang 생성
function makeWheel() {
    clearBangs();

    initialAngles1 = [];
    initialAngles2 = [];

    // 첫 번째 바퀴
    for (var i = 0; i < numBangs; i++) {
        var angle = (i / numBangs) * 2 * Math.PI;
        initialAngles1.push(angle);

        var x = centerX1 + radius * Math.cos(angle);
        var y = centerY1 + radius * Math.sin(angle);

        var b = this.patcher.newdefault(x, y, "button");
        bangObjs1.push(b);
    }

    // 두 번째 바퀴
    for (var i = 0; i < numBangs; i++) {
        var angle = (i / numBangs) * 2 * Math.PI;
        initialAngles2.push(angle);

        var x = centerX2 + radius * Math.cos(angle);
        var y = centerY2 + radius * Math.sin(angle);

        var b = this.patcher.newdefault(x, y, "button");
        bangObjs2.push(b);
    }

    // 바퀴 연결
    connectWheel(bangObjs1);
    connectWheel(bangObjs2);

    // 고정 bang 생성
    for (var i = 0; i < fixedBangs.length; i++) {
        var coords = fixedBangs[i];
        var b = this.patcher.newdefault(coords[0], coords[1], "button");
        fixedBangObjs.push(b);
    }

    // 고정 bang 연결
    for (var i = 0; i < fixedConnections.length; i++) {
        var src = fixedConnections[i][0];
        var dst = fixedConnections[i][1];
        if (fixedBangObjs[src] && fixedBangObjs[dst]) {
            this.patcher.connect(fixedBangObjs[src], 0, fixedBangObjs[dst], 0);
        }
    }
}

// 바퀴 연결 함수
function connectWheel(bangArray) {
    for (var i = 0; i < numBangs; i++) {
        var next = (i + 1) % numBangs;
        this.patcher.connect(bangArray[i], 0, bangArray[next], 0);
    }
    for (var i = 0; i < numBangs / 2; i++) {
        var opposite = (i + numBangs / 2) % numBangs;
        this.patcher.connect(bangArray[i], 0, bangArray[opposite], 0);
    }
}

// 회전용 inlet: 0~360 입력
function msg_float(deg) {
    if (inlet === 1) {
        var rad = deg * Math.PI / 180; // 라디안 변환
        rotateTo(rad);
    }
}

// 절대값 회전
function rotateTo(angleRad) {
    for (var i = 0; i < numBangs; i++) {
        // 첫 번째 바퀴
        var x1 = centerX1 + radius * Math.cos(initialAngles1[i] + angleRad);
        var y1 = centerY1 + radius * Math.sin(initialAngles1[i] + angleRad);
        var b1 = bangObjs1[i];
        if (b1) b1.rect = [x1, y1, x1 + 24, y1 + 24];

        // 두 번째 바퀴
        var x2 = centerX2 + radius * Math.cos(initialAngles2[i] + angleRad);
        var y2 = centerY2 + radius * Math.sin(initialAngles2[i] + angleRad);
        var b2 = bangObjs2[i];
        if (b2) b2.rect = [x2, y2, x2 + 24, y2 + 24];
    }
}

// bang 제거
function clearBangs() {
    while (bangObjs1.length > 0) this.patcher.remove(bangObjs1.pop());
    while (bangObjs2.length > 0) this.patcher.remove(bangObjs2.pop());
    while (fixedBangObjs.length > 0) this.patcher.remove(fixedBangObjs.pop());
}
