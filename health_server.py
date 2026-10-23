import http.server, threading, os

def serve():
    port = int(os.environ.get("PORT", "8000"))
    class H(http.server.BaseHTTPRequestHandler):
        def do_GET(self):
            self.send_response(200)
            self.send_header("Content-Length", "2")
            self.end_headers()
            self.wfile.write(b"ok")
        def log_message(self, *a): pass
    http.server.HTTPServer(("0.0.0.0", port), H).serve_forever()

threading.Thread(target=serve, daemon=True).start()
