import luxe.States;
import luxe.Vector;
import luxe.Sprite;
import luxe.Component;
import phoenix.Texture;
import luxe.tilemaps.Tilemap;
import luxe.collision.shapes.*;
import luxe.collision.ShapeDrawerLuxe;

class PlayState extends State {

    var player : Sprite;
    var player_component : Player;
    var player_desired_position : Vector;
    var tilemap : Tilemap;
    var shape_drawer : ShapeDrawerLuxe;

    public function new(_name:String, _tilemap:Tilemap, _player:Sprite) {
        super({ name:_name });
        tilemap = _tilemap;
        player = _player;
    } //new

    override function init() {

        shape_drawer = new ShapeDrawerLuxe();

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

        var tiles_player_is_on = get_surrounding_tiles_at_position(_player);
        var poly = create_a_polygon(tiles_player_is_on[7]);
        shape_drawer.drawPolygon(poly);
        // for(tile in tiles_player_is_on) {
        //     var poly = create_a_polygon(tile);

        //     if(Main.draw_colliders) {
        //         shape_drawer.drawPolygon(poly);
        //     }
        // }

        // if(tilemap.tile_at('ground', tiles_player_is_on.x + 1, tiles_player_is_on.y).id != 0) {
        //     trace('hit');
        // }
        // trace(tile_player_is_on);

    } //check_for_and_resolve_collisions

    function get_surrounding_tiles_at_position(_player:Sprite) {
        // take the player's tile position, build an array of the 8 surrounding tiles (not including the one he's on)
        // organize the tiles in the correct order (check the tutorial)
        // return an array that we can pass into the check collisions function

        var array_of_tiles_surrounding_player : Array<Tile> = [];
        var player_tile_position = tilemap.worldpos_to_map(_player.pos);

        for(i in 0...9) {
            var c = i % 3; // 012 012 012
            var r = Std.int(i / 3); // 000 111 222
            var tile_player_is_on = tilemap.tile_at('ground', Std.int(player_tile_position.x + (c - 1)), Std.int(player_tile_position.y + (r - 1)));
            array_of_tiles_surrounding_player.push(tile_player_is_on);
        }

        return array_of_tiles_surrounding_player;

    } //get_surrounding_tiles_at_position

    function create_a_polygon(_tile:Tile) {

        return Polygon.rectangle(_tile.pos.x, _tile.pos.y, _tile.size.x, _tile.size.y, false);

    } //create_a_polygon

} //PlayState
