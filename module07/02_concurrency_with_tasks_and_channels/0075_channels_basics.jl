chan = Channel{String}(3)


function producer(c::Channel, id::Int, num_messages::Int)
    println("Produced $id: Starting...")
    for i in 1:num_messages
        message = "Producer $id - Message $i"
        println("Producer $id: Putting '$message'")
        put!(c, message)
        sleep(rand() * 0.5)
    end
    println("Producer $id: Finished putting messages.")
end


function consumer(c::Channel, id::Int)
    println("Consumer $id: Starting...")
    for message in c
        println("Consumer $id: Received '$message'")
        sleep(rand() * 0.7)
    end
    println("Consumer $id: Channel closed and empty. Finishing.")
end

println("--- Starting Producer/Consumer with Channel ---")

@sync begin
    @async consumer(chan, 1)
    @async consumer(chan, 2)

    sleep(0.1)

    @async producer(chan, 1, 4)
    @async producer(chan, 2, 3)

    println("Main: Waiting for producers to likely finish...")
    sleep(4.0)

    println("Main: Closing the channel...")
    close(chan)

    println("Main: Channel closed. @sync will now wait for consumers to finish.")
end

println("--- All tasks finished ---")
