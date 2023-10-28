# A simple 3d character controller for godot

![](https://github.com/nanocarvalho/Simple_3D_Character_Movement_Godot/blob/main/demonstration.gif)


Resources I used to try and understand how to make the move and camera, in the end is a little of all of them haha:
- https://kidscancode.org/godot_recipes/4.x/3d/assets/character_controller/
- https://www.reddit.com/r/godot/comments/1565gj6/how_to_make_player_face_the_direction_theyre/?rdt=61568
- https://kidscancode.org/godot_recipes/4.x/3d/rotate_interpolate/index.html
- [KidsCanCode: Godot 4 3d character movement](https://www.youtube.com/watch?v=EP5AYllgHy8)
- [Lukky Godot 4 Third Person Controller](https://youtu.be/EP5AYllgHy8)
On the Lukky tutorial, the look_at(position + direction) not worked, until I saw a comment saying that the look_at only works in global space, so needs to be look_at(global_position + direction), but in my tests this is  instant rotation haha.