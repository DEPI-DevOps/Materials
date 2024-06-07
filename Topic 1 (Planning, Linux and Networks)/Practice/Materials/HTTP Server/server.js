const http = require("http");

const server = http.createServer((req, res) => {
    res.writeHead(200);
    res.end("Hello, World!");
});

server.listen(8000, '0.0.0.0', () => {
    console.log(`Server is running on http://0.0.0.0:8000`);
});
