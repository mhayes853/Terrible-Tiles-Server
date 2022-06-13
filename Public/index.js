/* A simple test bench for testing game interactions */

const playerX = document.getElementById("player-x");
const playerY = document.getElementById("player-y");
const dropped = document.getElementById("dropped");
const items = document.getElementById("items")
const countTimer = document.getElementById("count-timer");
const score = document.getElementById("score");

let secondsPassed = 0;
let isGameOver = false;

const controls = new Set();

const ws = new WebSocket("ws://localhost:8080/game/connect");

ws.onmessage = async (e) => {
    const data = JSON.parse(await e.data.text());
    console.log(data);
    
    if (data.playerPosition != undefined) {
        playerX.innerHTML = `x: ${data.playerPosition.x}`;
        playerY.innerHTML = `y: ${data.playerPosition.y}`;
        dropped.innerHTML = filterMapJoinTiles(data.filledTiles, (tile) => tile.type === "VOID");
        items.innerHTML = filterMapJoinTiles(data.filledTiles, (tile) => tile.type !== "VOID");
    }
    
    if (data.playerScore != undefined) {
        isGameOver = true;
    }
}

const filterMapJoinTiles = (tiles, condition) => {
    return tiles.filter(tile => condition(tile))
        .map(tile => `(${tile.position.x}, ${tile.position.y}, ${tile.type})`)
        .join(" ")
}

const MOVE_LEFT = "MOVE_LEFT";
const MOVE_RIGHT = "MOVE_RIGHT";
const MOVE_DOWN = "MOVE_DOWN";
const MOVE_UP = "MOVE_UP";

document.onkeydown = (e) => {
    let shouldSendControls = false;
    
    switch (event.key) {
        case "ArrowLeft":
            if (controls.has(MOVE_LEFT)) return;
            controls.add(MOVE_LEFT);
            shouldSendControls = true;
            break;
        case "ArrowRight":
            if (controls.has(MOVE_RIGHT)) return;
            controls.add(MOVE_RIGHT);
            shouldSendControls = true;
            break;
        case "ArrowUp":
            if (controls.has(MOVE_UP)) return;
            controls.add(MOVE_UP);
            shouldSendControls = true;
            break;
        case "ArrowDown":
            if (controls.has(MOVE_DOWN)) return;
            controls.add(MOVE_DOWN);
            shouldSendControls = true;
            break;
        default:
            break;
    }
    
    if (shouldSendControls) sendControls();
}

document.onkeyup = (e) => {
    switch (event.key) {
        case "ArrowLeft":
            controls.delete(MOVE_LEFT);
            break;
        case "ArrowRight":
            controls.delete(MOVE_RIGHT);
            break;
        case "ArrowUp":
            controls.delete(MOVE_UP);
            break;
        case "ArrowDown":
            controls.delete(MOVE_DOWN);
            break;
        default:
            break;
    }
    
    sendControls();
}

const sendControls = () => {
    ws.send(JSON.stringify([...controls]));
}

setInterval(() => {
    if (isGameOver) return;
    countTimer.innerHTML = `${secondsPassed}`;
    secondsPassed++;
}, 1000);
