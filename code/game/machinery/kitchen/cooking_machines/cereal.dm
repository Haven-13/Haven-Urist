/obj/machinery/cooker/cereal
	name = "cereal maker"
	desc = "Now with Dann O's available!"
	icon = 'resources/icons/obj/cooking_machines.dmi'
	icon_state = "cereal_off"
	cook_type = "cerealized"
	on_icon = "cereal_on"
	off_icon = "cereal_off"

/obj/machinery/cooker/cereal/change_product_strings(obj/item/weapon/reagent_containers/food/snacks/product)
	. = ..()
	product.SetName("box of [cooking_obj.name] cereal")

/obj/machinery/cooker/cereal/change_product_appearance(obj/item/weapon/reagent_containers/food/snacks/product)
	product.icon = 'resources/icons/obj/food.dmi'
	product.icon_state = "cereal_box"
	product.filling_color = cooking_obj.color

	var/image/food_image = image(cooking_obj.icon, cooking_obj.icon_state)
	food_image.color = cooking_obj.color
	food_image.overlays += cooking_obj.overlays
	food_image.transform *= 0.7

	product.overlays += food_image

