package tart.core {

    import flash.utils.Dictionary;

    import dessert_knife.knife;

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
                component.onDetach();
            }
            _componentList.length = 0;

            knife.map.clear(_componentMap);
        }

        public function get componentList():Vector.<Component> {
            return _componentList;
        }

        public function getComponent(componentClass:Class):Component {
            return _componentMap[componentClass] || null;
        }

        public function attach(component:Component):Entity {
            var klass:Class = component.getClass();
            if (!klass) { throw new Error("Invalid component: Class not defined."); }
            if (_componentMap[klass]) {
                throw new Error("Component already attached: type = " + klass);
            }

            _componentMap[klass] = component;
            _componentList.push(component);
            component.entity = this;
            component.onAttach();
            return this;
        }

    }
}
