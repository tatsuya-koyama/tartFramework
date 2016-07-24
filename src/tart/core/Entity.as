package tart.core {

    import flash.utils.Dictionary;

    public class Entity {

        public var scope:ISceneScope;
        public var isAlive:Boolean;

        private var _componentMap:Dictionary;  // {Class.<Component> : Component}
        private var _componentList:Vector.<Component>;

        public function Entity() {
            scope   = null;
            isAlive = false;

            _componentMap  = new Dictionary();
            _componentList = new Vector.<Component>();
        }

        public function recycle():void {
            scope   = null;
            isAlive = false;

            for each (var component:Component in _componentList) {
                component.recycle();
                component.reset();
            }
            _componentList.length = 0;

            for (var klass:Class in _componentMap) {
                delete _componentMap[klass];
            }
        }

        public function get componentList():Vector.<Component> {
            return _componentList;
        }

        public function getComponent(componentClass:Class):Component {
            return _componentMap[componentClass] || null;
        }

        public function attach(component:Component):Entity {
            var klass:Class = component.getClass();
            if (!klass) { throw new Error("Invalid component: Class not found."); }
            if (_componentMap[klass]) {
                throw new Error("Component already attached: typeId = " + klass);
            }

            _componentMap[klass] = component;
            _componentList.push(component);
            component.entity = this;
            return this;
        }

    }
}
