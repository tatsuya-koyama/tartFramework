package tart.components {

    import tart.core.Component;

    public class Transform extends Component {

        public var x:Number;
        public var y:Number;
        public var z:Number;

        public override function getClass():Class {
            return Transform;
        }

        public override function reset():void {
            x = 0;
            y = 0;
            z = 0;
        }

    }
}
