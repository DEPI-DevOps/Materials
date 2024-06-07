# Setting up a simple HTTP server

## Approach 1: serving a static HTML file

1. Create `index.html` in some directory.

   ```html
   <!DOCTYPE html>
   <html>
       <head>
           <title>Example</title>
       </head>
       <body>
           <h1>Hello, World!</h1>
       </body>
   </html>
   ```

2. Start a local HTTP static file server in the same directory

   - Python

     ```bash
     python -m http.server 8000
     ```

   - Node.js

     ```bash
     npm install -g http-server
     http-server
     ```

3. Visit <http://localhost:8000> to access your server.

## Approach 2: handling everything from a script

1. Python script. Run with `python server.py`

   ```python
   import http.server
   import socketserver
   from http import HTTPStatus
   
   class Handler(http.server.SimpleHTTPRequestHandler):
       def do_GET(self):
           self.send_response(HTTPStatus.OK)
           self.end_headers()
           self.wfile.write(b'Hello world')
   
   
   httpd = socketserver.TCPServer(('', 8000), Handler)
   httpd.serve_forever()
   ```

2. Node.js script. Run with `node server.js`

   ```js
   const http = require("http");
   
   const server = http.createServer((req, res) => {
       res.writeHead(200);
       res.end("Hello, World!");
   });
   
   server.listen(8000, '0.0.0.0', () => {
       console.log(`Server is running on http://0.0.0.0:8000`);
   });
   ```

## Extra: bash one-liner to accomplish the task

```bash
while true; do echo -e "HTTP/1.1 200 OK\n\n<h1>Hello, World</h1>" | nc -l -k -p 8080 -q 1; done
```

**Explanation:**

- The command runs [netcat](https://en.wikipedia.org/wiki/Netcat) (`nc`) in an infinte loop, sending the specified HTTP response message whenever a client connects to the listening server.
- Flag `-l` is used to listen for incoming TCP connections.
- Flag `-p 8000` is used to bind port 8000 to the listening server.
- Flag `-q 1` is used to make netcat wait the specified number of seconds after EOF on stdin and  then quit. It allows graceful termination of the TCP connection.
- The `-e` flag for `echo` is used to allow the interpretation of special characters (for `\n` to be interpreted as an empty line).
