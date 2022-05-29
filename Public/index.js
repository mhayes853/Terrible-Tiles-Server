const playerX = document.getElementById("player-x");
const playerY = document.getElementById("player-y");

const ws = new WebSocket("ws://localhost:8080/game/connect");

ws.onmessage = async (e) => {
    const data = JSON.parse(await e.data.text());
    console.log(data);
    
    playerX.innerHTML = `x: ${data.playerPosition.x}`;
    playerY.innerHTML = `y: ${data.playerPosition.y}`;
}

document.onkeydown = (e) => {
    switch (event.key) {
        case "ArrowLeft":
            sendData({ inputCommand: "MOVE_LEFT" });
            break;
        case "ArrowRight":
            sendData({ inputCommand: "MOVE_RIGHT" });
            break;
        case "ArrowUp":
            sendData({ inputCommand: "MOVE_UP" });
            break;
        case "ArrowDown":
            sendData({ inputCommand: "MOVE_DOWN" });
            break;
    }
}

const sendData = (obj) => {
    ws.send(JSON.stringify(obj));
}
