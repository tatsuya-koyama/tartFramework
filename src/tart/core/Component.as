package tart.core {

    public class Component {

        private var _entity:Entity;  // Entity that this Component is attached

        public function Component() {}

        public function set entity(entity:Entity):void {
            _entity = entity;
        }

        public function getComponent(componentClass:Class):Component {
            return _entity.getComponent(componentClass);
        }

        public function getClass():Class {
            // implement in subclasses
            return null;
        }

        public function reset():void {}

    }
}
