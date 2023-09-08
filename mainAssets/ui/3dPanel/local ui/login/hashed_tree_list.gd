class_name hashed_tree_list
extends Tree

var tree:Dictionary = {}

func add_item(text:String,metadata:Variant):
	if tree.has(metadata['room_id']) and tree[metadata['room_id']]['name'] == metadata['room_id']:
		tree[metadata['room_id']]['name'] = text
		tree[metadata['room_id']]['tree_item'].set_text(0,text)
#		tree[metadata['room_id']]['tree_item'].set_metadata(0, metadata)
	else:
		var roomdict = {
			"name": text,
			"tree_item": create_item()
		}
		for event in metadata["state"]:
			match event.type:
				"m.space.child":
					if tree.has(event['state_key']):
						await get_tree().process_frame
						tree[event['state_key']]['tree_item'].get_parent().remove_child(tree[event['state_key']]['tree_item'])
						roomdict['tree_item'].add_child(tree[event['state_key']]['tree_item'])
					else:
						tree[event["state_key"]] = {
							"name": event["state_key"],
							"tree_item": create_item(roomdict["tree_item"]),
							"parent": metadata['room_id']
						}
						tree[event['state_key']]['tree_item'].set_text(0,event['state_key'])
		var room_id = metadata["room_id"]
		tree[room_id] = roomdict
		roomdict['tree_item'].set_text(0,text)
#		roomdict['tree_item'].set_metadata(0,metadata)
	
