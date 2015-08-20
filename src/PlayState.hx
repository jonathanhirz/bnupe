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

    } //onenter

    override function onleave<T>(_value:T) {


    } //onleave

    override function update(dt:Float) {

        //@todo: check if tile we are checking is off the map...causes crash

        // check_for_and_resolve_collisions(player);
        for(ob in obstacles) {
            if(Main.draw_colliders) shape_drawer.drawPolygon(ob);
            var coll = Collision.shapeWithShape(player_collider, ob);
            if(coll != null) {
                // below
                if(coll.separation.y < 0) {
                    if(player_component.velocity.y >= 0) {
                        player.pos.y += coll.separation.y;
                        player_component.velocity.y = 0;
                        player_component.on_ground = true;
                    }
                }
                // above
                if(coll.separation.y > 0) {
                    if(player_component.velocity.y <= 0) {
                        player.pos.y += coll.separation.y;
                        player_component.velocity.y = 0;
                    }
                }
                //left
                if(coll.separation.x > 0) {
                    if(player_component.velocity.x <= 0) {
                        player.pos.x += coll.separation.x;
                        player_component.velocity.x = 0;
                    }
                }
                // right
                if(coll.separation.x < 0) {
                    if(player_component.velocity.x >= 0) {
                        player.pos.x += coll.separation.x;
                        player_component.velocity.x = 0;
                    }
                }
            }
        }

    } //update

} //PlayState
