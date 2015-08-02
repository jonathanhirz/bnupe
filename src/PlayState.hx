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

        // var player_tile_position = tilemap.worldpos_to_map(player_desired_position);
        // player_desired_position = player_component.desired_position;

        check_for_and_resolve_collisions(player);

        player.pos = player_desired_position;


    } //update

    function check_for_and_resolve_collisions(_player:Sprite) {
        // get player's bounding box collider
        // for every collision between the player and a tile in the array,
        // check the position in the array of the collision (this gives priority)
        // resolve accordingly, update desired position

        var tile_player_is_on = get_surrounding_tiles_at_position(_player);
        if(tilemap.tile_at('ground', tile_player_is_on.x + 1, tile_player_is_on.y).id != 0) {
            trace('hit');
        }
        // trace(tile_player_is_on);

    } //check_for_and_resolve_collisions

    function get_surrounding_tiles_at_position(_player:Sprite) {
        // take the player's tile position, build an array of the 8 surrounding tiles (not including the one he's on)
        // organize the tiles in the correct order (check the tutorial)
        // return an array that we can pass into the check collisions function

        var player_tile_position = tilemap.worldpos_to_map(_player.pos);
        var tile_player_is_on = tilemap.tile_at('ground', Std.int(player_tile_position.x), Std.int(player_tile_position.y));
        return tile_player_is_on;

    } //get_surrounding_tiles_at_position

} //PlayState