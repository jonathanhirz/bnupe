import luxe.States;
import luxe.Vector;
import luxe.Sprite;
import luxe.Component;
import phoenix.Texture;
import luxe.tilemaps.Tilemap;

class PlayState extends State {

    var player : Sprite;
    var player_component : Player;
    var player_desired_position : Vector;
    var tilemap : Tilemap;

    public function new(_name:String, _tilemap:Tilemap, _player:Sprite) {
        super({ name:_name });
        tilemap = _tilemap;
        player = _player;
    } //new

    override function init() {


    } //init

    override function onenter<T>(_value:T) {

        tilemap.display({ 
            // grid:true 
        });
        player.visible = true;
        player_component = player.get('player');

        player_desired_position = player_component.desired_position;

    } //onenter

    override function onleave<T>(_value:T) {


    } //onleave

    override function update(dt:Float) {

        //@todo: check if tile we are checking is off the map...causes crash

        var player_tile_position = tilemap.worldpos_to_map(player_desired_position);
        player_desired_position = player_component.desired_position;

        // get_surrounding_tiles_at_position() [build an array of the 8 tiles around the player, organized]
        // check_for_and_resolve_collisions() [check for a collision with player/world, check where that collision lands in the array, resolve accordingly]


        player.pos = player_desired_position;


    } //update

    function get_surrounding_tiles_at_position(_player_tile_position:Vector) {
        // take the player's tile position, build an array of the 8 surrounding tiles (not including the one he's on)
        // organize the tiles in the correct order (check the tutorial)
        // return an array that we can pass into the check collisions function

    } //get_surrounding_tiles_at_position

    function check_for_and_resolve_collisions(_player:Sprite) {
        // get player's bounding box collider
        // for every collision between the player and a tile in the array,
        // check the position in the array of the collision (this gives priority)
        // resolve accordingly, update desired position
        // update player position


    } //check_for_and_resolve_collisions

} //PlayState