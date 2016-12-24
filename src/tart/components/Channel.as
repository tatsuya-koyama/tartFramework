package tart.components {

    import tart.core.Component;
    import dessert_knife.tools.signal.MessageChannel;

    public class Channel extends Component {

        public var messageChannel:MessageChannel;

        public function Channel() {
            messageChannel = new MessageChannel();
        }

        public override function getClass():Class {
            return Channel;
        }

        public override function onDetach():void {
            messageChannel.reset();
        }

    }
}
