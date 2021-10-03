/obj/structure/curtain/var/id = null

/obj/machinery/button/remote/curtains
	name = "remote curtains-control"
	desc = "It controls curtains, remotely."

/obj/machinery/button/remote/curtains/trigger()
	for(var/obj/structure/curtain/D in world)
		if(D.id == src.id)
			D.toggle()
