package tart.core {

    import flash.display.Sprite;
    import flash.events.Event;
    import flash.utils.Dictionary;

    import away3d.core.managers.Stage3DProxy;

    import dessert_knife.tools.async.Defer;

    public class TartEngine {

        private var _tartContext:TartContext;
        private var _componentMap:Dictionary;

        public function TartEngine() {
            _componentMap = new Dictionary();
        }

        //----------------------------------------------------------------------
        // public
        //----------------------------------------------------------------------

        public function boot(bootConfig:IBootConfig):Defer {
            var bootSequence:BootSequence = new BootSequence(bootConfig);
            return bootSequence.runAsync(this)
                .then(function(tartContext:TartContext):TartContext {
                    _tartContext = tartContext;
                    _initMainLoop(_tartContext.graphics);
                    return tartContext;
                });
        }

        public function getComponents(componentClass:Class):Array {
            return _componentMap[componentClass];
        }

        public function createActor(actor:TartActor, scope:ISceneScope):void {
            // ToDo: scope の管理
            var entity:Entity = new Entity;
            entity.attach(actor);

            var recipe:Array = actor.recipe();
            if (recipe) {
                for each (var componentClass:Class in recipe) {
                    // ToDo: pooling
                    var component:Component = new componentClass() as Component;
                    entity.attach(component);
                }
            }
            addEntity(entity);
        }

        public function addEntity(entity:Entity):void {
            var components:Vector.<Component> = entity.componentList;
            for each (var component:Component in components) {
                _addComponent(component);
            }
        }

        //----------------------------------------------------------------------
        // private
        //----------------------------------------------------------------------

        private function _initMainLoop(graphics:TartGraphics):void {
            var stage3DProxy:Stage3DProxy = graphics.stage3DProxy;
            stage3DProxy.addEventListener(Event.ENTER_FRAME, _mainLoop);
        }

        private function _mainLoop(event:Event):void {
            var deltaTime:Number = 1 / 60; // ToDo
            _tartContext.system.process(deltaTime);
        }

        private function _addComponent(component:Component):void {
            var klass:Class = component.getClass();
            if (!_componentMap[klass]) {
                _componentMap[klass] = [];
            }
            _componentMap[klass].push(component);
        }

        //----------------------------------------------------------------------
        // for debugging or testing
        //----------------------------------------------------------------------

        public function get tartContext():TartContext {
            return _tartContext;
        }

    }
}
