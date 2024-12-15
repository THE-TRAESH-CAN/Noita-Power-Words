const shitList = [
    {
        event: "GoldTouchy",
        matches: ["money", "gold", "moola"]
    },
    {
        event: "Acid",
        matches: ["ass"]
    },
    {
        event: "Hentai",
        matches: ["weeb", "weebs", "web", "webe", "weed", "weaves", "slurp"]
    },
    {
        event: "WormLauncher",
        matches: ["zoom", "soon"]
    },
    {
        event: "Ukko",
        matches: ["old", "gramp"]
    },
    {
        event: "Steve",
        matches: ["god", "steve"]
    },
    {
        event: "Trip",
        matches: ["high", "hai"]
    },
    {
        event: "Tanks",
        matches: ["thank", "tank"]
    },
    {
        event: "Cocktail",
        matches: ["throw"]
    },
    {
        event: "LavaShift",
        matches: ["lava"]
    },
    {
        event: "Goblins",
        matches: ["greed"]
    },
    {
        event: "Toasters",
        matches: ["bread", "loaf"]
    }

]
const shit = new webkitSpeechRecognition
shit.continuous = true
shit.lang = "en-US"
shit.onresult = function (event) {
    const res = event.results[event.results.length - 1][0]
    if (res.transcript) {
        for (const entry of shitList) {
            for (const match of entry.matches) {
                if (res.transcript.toLowerCase().includes(match)) {
                    ass.send(`{ event: "${entry.event}" }`)
                }
            }
        }
    }
}
shit.start()

function openSock (evt) {
    console.log("Connected ?")
}

function reconnectSock() {
    ass = new WebSocket("ws://localhost:6969")
    ass.onopen = openSock
    ass.onclose = reconnectSock
}
reconnectSock()