import luxe.States;
import luxe.Vector;
import luxe.Sprite;
import luxe.Component;
import phoenix.Texture;
import luxe.Rectangle;
import luxe.tilemaps.Tilemap;
import luxe.collision.Collision;
import luxe.collision.shapes.*;
import luxe.collision.ShapeDrawerLuxe;

class PlayState extends State {

    var player : Sprite;
    var player_component : Player;
    var player_collider : Polygon;
    var player_desired_position : Vector;
    var tilemap : Tilemap;
    var tilemap_colliders : Array<Rectangle>;
    var obstacles : Array<Polygon>;
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
        var tilemap_colliders = tilemap.layer('ground').bounds_fitted();
        obstacles = [];
        var tile_w = 32;
        var tile_h = 32;
        for(collider in tilemap_colliders) {
            collider.x *= tile_w;
            collider.y *= tile_h;
            collider.w *= tile_w;
            collider.h *= tile_h;
            obstacles.push(Polygon.rectangle(collider.x, collider.y, collider.w, collider.h, false));
        }
        // notes from Sven
        // var bounds = map.layer('collision').bounds_fitted();
        // var tile_w = 16;
        // var tile_h = 16;
        // for(bound in bounds) {
        //     bound.x *= tile_w * scale;
        //     bound.y *= tile_h * scale;
        //     bound.w *= tile_w * scale;
        //     bound.h *= tile_h * scale;
        //     obstacles.push(Polygon.rectangle(bound.x, bound.y, bound.w, bound.h, false));
        // }
        player.visible = true;
        player_component = player.get('player');
        player_collider = player.get('player_collider').block_collider;

        player_desired_position = player_component.desired_position;

    } //onenter

    override function onleave<T>(_value:T) {


    } //onleave

    override function update(dt:Float) {

        //@todo: check if tile we are checking is off the map...causes crash

        // check_for_and_resolve_collisions(player);
        for(ob in obstacles) {
            var coll = Collision.shapeWithShape(player_collider, ob);
            if(coll != null) {
                // below
                if(coll.separation.y < 0) {
                    if(player_component.velocity.y >= 0) {
                        player_desired_position.y += coll.separation.y;
                        player_component.velocity.y = 0;
                        player_component.on_ground = true;
                    }
                }
                // above
                if(coll.separation.y > 0) {
                    if(player_component.velocity.y <= 0) {
                        player_desired_position.y += coll.separation.y;
                        player_component.velocity.y = 0;
                    }
                }
                //left
                if(coll.separation.x > 0) {
                    if(player_component.velocity.x <= 0) {
                        player_desired_position.x += coll.separation.x;
                        player_component.velocity.x = 0;
                    }
                }
                // right
                if(coll.separation.x < 0) {
                    if(player_component.velocity.x >= 0) {
                        player_desired_position.x += coll.separation.x;
                        player_component.velocity.x = 0;
                    }
                }
            }
        }

        player.pos = player_desired_position;


    } //update

    function check_for_and_resolve_collisions(_player:Sprite) {
        // get player's bounding box collider
        // for every collision between the player and a tile in the array,
        // check the position in the array of the collision (this gives priority)
        // resolve accordingly, update desired position

        var tiles_player_is_on = get_surrounding_tiles_at_position(_player);

        for(tile in tiles_player_is_on) {
            if(tile.id > 0) {
                var poly = create_a_polygon(tile);
                var coll = Collision.shapeWithShape(player_collider, poly);
                if(coll != null) {
                    var tile_index = tiles_player_is_on.indexOf(tile);
                    // index7 below
                    if(tile_index == 7 && player_component.velocity.y >= 0) {
                        player_desired_position.y += coll.separation.y;
                        player_component.velocity.y = 0;
                        player_component.on_ground = true;
                    }
                    // index1 above
                    if(tile_index == 1 && player_component.velocity.y <= 0) {
                        player_desired_position.y += coll.separation.y;
                        player_component.velocity.y = 0;

                    }
                    // index3 left
                    if(tile_index == 3 && player_component.velocity.x <= 0) {
                        player_desired_position.x += coll.separation.x;
                        player_component.velocity.x = 0;
                    }
                    // index5 right
                    if(tile_index == 5 && player_component.velocity.x >= 0) {
                        player_desired_position.x += coll.separation.x;
                        player_component.velocity.x = 0;
                    } 
                    // diagonals
                    //todo: fix the bounce that sometimes happens. I think it's because it is adding the seperation.y twice                        
                    if(coll.separation.x > coll.separation.y) {
                        //resolve up
                        if(tile_index == 6 && player_component.velocity.y >= 0) {
                            player_desired_position.y += coll.separation.y;
                            player_component.velocity.y = 0;
                            player_component.on_ground = true;
                        }
                        if(tile_index == 8 && player_component.velocity.y >= 0) {
                            player_desired_position.y += coll.separation.y;
                            player_component.velocity.y = 0;
                            player_component.on_ground = true;
                        }
                    }
                }

                if(Main.draw_colliders) {
                    // shape_drawer.drawPolygon(poly);
                    // shape_drawer.drawPolygon(player_poly);
                }
            }
        }
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
