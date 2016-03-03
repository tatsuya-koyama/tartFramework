package tart.core {

    import flash.display.Sprite;
    import flash.events.Event;
    import flash.utils.Dictionary;

    import away3d.core.managers.Stage3DProxy;

    public class TartEngine {

        private var _tartContext:TartContext;
        private var _componentMap:Dictionary;

        public function TartEngine() {
            _componentMap = new Dictionary();
        }

        //----------------------------------------------------------------------
        // public
        //----------------------------------------------------------------------

        public function boot(bootConfig:IBootConfig):void {
            var bootSequence:BootSequence = new BootSequence(bootConfig);
            bootSequence.runAsync().then(function(tartContext:TartContext):void {
                _tartContext = tartContext;
                _initMainLoop(_tartContext.graphics);
            });
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
                _componentMap[klass] = new Vector.<Component>();
            }
            _componentMap[klass].push(component);
        }

    }
}
