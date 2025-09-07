inlets = 5; // 0=초기화 bang, 1=왼손 MIDI, 2=오른손 MIDI, 3=왼쪽 bang X 이동, 4=오른쪽 bang X 이동
outlets = 0;

var octaves = 3;
var startAtMidiC = 36;

var whiteWidth = 30;
var whiteHeight = 120;
var whiteGap = 2;

var blackWidth = 20;
var blackHeight = 80;
var blackOffsetY = 0;

var x0 = 57.5;
var y0 = 450;

var createdKeys = [];
var blackKeys = [];

var bangLeft = null;
var bangRight = null;

var NAMES = ["C","C#","D","D#","E","F","F#","G","G#","A","A#","B"];
var WHITE_INDEX = [0,2,4,5,7,9,11];
var BLACK_INDEX = [1,3,6,8,10]; 
var BLACK_POSITION_MAP = [
    {left:0, right:1}, // C# : C-D 사이
    {left:1, right:2}, // D# : D-E 사이
    {left:3, right:4}, // F# : F-G 사이
    {left:4, right:5}, // G# : G-A 사이
    {left:5, right:6}  // A# : A-B 사이
];

// === 초기화 ===
function bang() {
    if(inlet != 0) return;
    clearKeys();
    createdKeys = [];
    blackKeys = [];

    var whiteKeys = [];

    // 흰건반 생성
    for(var o=0; o<octaves; o++){
        for(var w=0; w<WHITE_INDEX.length; w++){
            var noteIndex = WHITE_INDEX[w];
            var pitch = startAtMidiC + o*12 + noteIndex;
            var x = x0 + (o*7 + w)*(whiteWidth + whiteGap);
            var y = y0;

            var s = this.patcher.newdefault(x, y, "slider");
            s.rect = [x, y, x+whiteWidth, y+whiteHeight];
            s.varname = "white_" + pitch;
            s.message("@orientation", "vertical");
            s.message("@min", 0);
            s.message("@max", 127);
            s.message("bgcolor", 0.8, 0.8, 0.8, 1);
            s.message("@elementcolor", 1, 1, 1, 1);

            createdKeys.push(s);
            whiteKeys.push({x:x, y:y, pitch:pitch, width:whiteWidth});
        }
    }

    // 검은건반 생성
    for(var o=0; o<octaves; o++){
        for(var b=0; b<BLACK_POSITION_MAP.length; b++){
            var pitch = startAtMidiC + o*12 + BLACK_INDEX[b];
            var leftWhite = whiteKeys[o*7 + BLACK_POSITION_MAP[b].left];
            var rightWhite = whiteKeys[o*7 + BLACK_POSITION_MAP[b].right];
            var x = 15 + leftWhite.x + (rightWhite.x - leftWhite.x)/2 - blackWidth/2;
            var y = y0 + blackOffsetY;

            var s = this.patcher.newdefault(x, y, "slider");
            s.rect = [x, y, x+blackWidth, y+blackHeight];
            s.varname = "black_" + pitch;
            s.message("@orientation", "vertical");
            s.message("@min", 0);
            s.message("@max", 127);
            s.message("bgcolor", 0.2, 0.2, 0.2, 1);
            s.message("@elementcolor", 0, 0, 0, 1);

            try { this.patcher.bringtofront(s); } catch(e){}
            createdKeys.push(s);
            blackKeys.push(s);
        }
    }

    post("Piano sliders created: " + createdKeys.length + "\n");

    createBang(whiteKeys);
}

// === bang 생성 (고정 위치) ===
function createBang(whiteKeys){
    var firstKey = whiteKeys[0];
    var lastKey = whiteKeys[whiteKeys.length-1];
    var firstX = firstKey.x;
    var lastX = lastKey.x + whiteWidth;

    var yBang = y0 + whiteHeight + 80; // 건반 아래 고정 위치

    if(!bangLeft){
        bangLeft = this.patcher.newdefault(firstX, yBang, "button");
        bangLeft.rect = [firstX, yBang, firstX+20, yBang+20];
        bangLeft.varname = "bang_left";
    }
    if(!bangRight){
        bangRight = this.patcher.newdefault(lastX-20, yBang, "button");
        bangRight.rect = [lastX-20, yBang, lastX, yBang+20];
        bangRight.varname = "bang_right";
    }
}

// === 슬라이더 제거 ===
function clearKeys(){
    var obj = this.patcher.firstobject;
    var toRemove = [];
    while(obj){
        try{
            if(obj.varname && ((""+obj.varname).indexOf("white_")===0 || (""+obj.varname).indexOf("black_")===0)){
                toRemove.push(obj);
            }
        } catch(e){}
        obj = obj.nextobject;
    }
    for(var i=0;i<toRemove.length;i++){
        this.patcher.remove(toRemove[i]);
    }
    post("Cleared piano sliders.\n");
}

// === MIDI 메시지 처리 ===
function list(){
    var args = arrayfromargs(arguments);

    if(inlet == 1){  // 왼손 MIDI (이전 오른손)
        handleMIDINote(args[0], args[1], bangLeft);
    } else if(inlet == 2){  // 오른손 MIDI (이전 왼손)
        handleMIDINote(args[0], args[1], bangRight);
    } else if(inlet == 3 && bangLeft){ 
        // 왼쪽 bang X 이동 (이전 오른쪽)
        var newX = args[0];
        var r = bangLeft.rect;
        bangLeft.rect = [newX, r[1], newX+20, r[3]];
    } else if(inlet == 4 && bangRight){
        // 오른쪽 bang X 이동 (이전 왼쪽)
        var newX = args[0];
        var r = bangRight.rect;
        bangRight.rect = [newX, r[1], newX+20, r[3]];
    }
}

// === MIDI 처리 ===
function handleMIDINote(pitch, velocity, bangObj){
    var targetSlider = findSlider(pitch);
    if(!targetSlider) return;

    targetSlider.message("float", velocity);

    if(velocity > 0){
        connectSliderToBang(targetSlider, bangObj);
    } else {
        disconnectSliderFromBang(targetSlider, bangObj);
    }
}

// === slider 찾기 ===
function findSlider(pitch){
    for(var i=0;i<createdKeys.length;i++){
        if(createdKeys[i].varname.indexOf("_"+pitch) >= 0){
            return createdKeys[i];
        }
    }
    return null;
}

// === 연결 관리 ===
function connectSliderToBang(slider, bangObj){
    try { this.patcher.connect(slider, 0, bangObj, 0); } catch(e){}
}
function disconnectSliderFromBang(slider, bangObj){
    try { this.patcher.disconnect(slider, 0, bangObj, 0); } catch(e){}
}
