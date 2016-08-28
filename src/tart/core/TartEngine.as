package tart.core {

    import flash.display.Sprite;
    import flash.events.Event;
    import flash.utils.getQualifiedClassName;
    import flash.utils.Dictionary;

    import away3d.core.managers.Stage3DProxy;

    import dessert_knife.tools.async.Defer;

    use namespace tart_internal;

    public class TartEngine {

        private var _tartContext:TartContext;
        private var _componentMap:Dictionary;  // {Class.<Component> : Vector.<Component>}
        private var _entities:Vector.<Entity>;
        private var _pendingEntities:Vector.<Entity>;

        public function TartEngine() {
            _componentMap    = new Dictionary();
            _entities        = new Vector.<Entity>();
            _pendingEntities = new Vector.<Entity>();
        }

        //----------------------------------------------------------------------
        // public
        //----------------------------------------------------------------------

        public function boot(bootConfig:IBootConfig):Defer {
            _tartContext = new TartContext();
            _tartContext.engine = this;

            var bootSequence:BootSequence = new BootSequence(bootConfig);
            return bootSequence.runAsync(_tartContext)
                .then(function(tartContext:TartContext):TartContext {
                    _initMainLoop(tartContext.graphics);
                    return tartContext;
                });
        }

        public function getComponents(componentClass:Class):Array {
            return _componentMap[componentClass];
        }

        public function buildActor(actor:TartActor):Entity {
            actor.tart = _tartContext;

            var entity:Entity = new Entity;
            entity.attach(actor);

            var recipe:Array = actor.recipe();
            if (recipe) {
                for each (var componentClass:Class in recipe) {
                    // ToDo: pooling
                    var component:Component = new componentClass() as Component;
                    component.tart = _tartContext;
                    entity.attach(component);
                }
            }

            actor.internalAwake();
            actor.awake();
            return entity;
        }

        public function addEntity(entity:Entity, scope:ISceneScope):void {
            // Gathers same components
            var components:Vector.<Component> = entity.componentList;
            for each (var component:Component in components) {
                _addComponent(component);
            }

            // Remembers entity and its scope
            entity.scope   = scope;
            entity.isAlive = true;
            _entities.push(entity);
        }

        public function addEntityAfterUpdate(entity:Entity, scope:ISceneScope):void {
            entity.scope = scope;
            _pendingEntities.push(entity);
        }

        public function removeEntity(entity:Entity):void {
            // todo
        }

        //----------------------------------------------------------------------
        // internal
        //----------------------------------------------------------------------

        tart_internal function addPendingEntities():void {
            if (_pendingEntities.length == 0) { return; }

            for each (var entity:Entity in _pendingEntities) {
                addEntity(entity, entity.scope);
            }
            _pendingEntities.length = 0;
        }

        tart_internal function disposeScopeEntities(scope:ISceneScope):void {
            for (var i:int = 0; i < _entities.length; ++i) {
                var entity:Entity = _entities[i];
                if (entity.scope != scope) { continue; }

                entity.recycle();
                _entities.removeAt(i);
                --i;
                // ToDo: pooling
            }
            _disposeDeadComponents();
        }

        tart_internal function disposeDeadEntities():void {
            for (var i:int = 0; i < _entities.length; ++i) {
                var entity:Entity = _entities[i];
                if (entity.isAlive) { continue; }

                entity.recycle();
                _entities.removeAt(i);
                --i;
                // ToDo: pooling
            }
            _disposeDeadComponents();
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

            component.isAlive = true;
        }

        private function _disposeDeadComponents():void {
            for each (var components:Array in _componentMap) {
                for (var i:int = 0; i < components.length; ++i) {
                    var component:Component = components[i];
                    if (component.isAlive) { continue; }

                    components.removeAt(i);
                    --i;
                    // ToDo: pooling
                }
            }
        }

        //----------------------------------------------------------------------
        // for debugging or testing
        //----------------------------------------------------------------------

        public function get tartContext():TartContext {
            return _tartContext;
        }

        public function debug_printStats():void {
            var numEntity:int     = _entities.length;
            var numComponents:int = 0;
            for each (var components:Array in _componentMap) {
                numComponents += components.length;
            }
            trace("[Debug :: TartEngine] E:", numEntity, ", C:", numComponents);
        }

        public function debug_dumpComponents():void {
            var obj:Object = {};
            for (var klass:Class in _componentMap) {
                var components:Array = _componentMap[klass];
                var className:String = getQualifiedClassName(klass);
                obj[className] = components.length;
            }
            trace("[Debug :: TartEngine] ***** Numbers of Components *****");
            trace(JSON.stringify(obj, null, 4));
        }

    }
}
