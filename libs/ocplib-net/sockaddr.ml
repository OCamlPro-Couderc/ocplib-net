
type t = Unix.sockaddr

let loopback port =
  Unix.ADDR_INET (Unix.inet_addr_of_string "127.0.0.1", port)

let any = Unix.ADDR_INET(Unix.inet_addr_any, 0)

let to_string = NetUtils.string_of_sockaddr
let of_ip ip port =
  Unix.ADDR_INET (Unix.inet_addr_of_string ip, port)
