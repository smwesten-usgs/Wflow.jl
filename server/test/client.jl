using ZMQ
using JSON

@info("start ZMQ server for Wflow (@async)")
@async begin
    include("../src/WflowBmiServer.jl")
end
sleep(2)
@info("Started ZMQ server for Wflow")

context = Context()

@info("Connecting to the ZMQ server for Wflow...")
socket = Socket(context, REQ)
ZMQ.connect(socket, "tcp://localhost:5555")

@info("Request Wflow initialization...")
message = Dict{String, Any}("fn" => "initialize", "path" => "../../test/sbm_config.toml")
ZMQ.send(socket, JSON.json(message))
message = String(ZMQ.recv(socket))
println("Received reply [ $message ]")

ZMQ.close(socket)
ZMQ.close(context)