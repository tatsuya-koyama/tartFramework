package {

    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.MouseEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.Socket;
    import flash.system.Capabilities;

    import tartlab.utils.PigmyButton;

    public class Main extends Sprite {

        private var _socket:Socket;

        public function Main() {
            _centeringWindowForDesktopApp();
            _initSocket();
            _initButtons();
        }

        private function _centeringWindowForDesktopApp():void {
            PLATFORM::DESKTOP {
                stage.nativeWindow.x = (Capabilities.screenResolutionX - stage.nativeWindow.width)  * 0.5;
                stage.nativeWindow.y = (Capabilities.screenResolutionY - stage.nativeWindow.height) * 0.5;
            }
        }

        private function _initSocket():void {
            _socket = new Socket("localhost", 3000);

            _socket.addEventListener(Event.CONNECT, _onSocketConnect);
            _socket.addEventListener(IOErrorEvent.IO_ERROR, _onSocketIOError);
            _socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _onSocketSecurityError);

            _socket.connect("localhost", 3000);
        }

        private function _onSocketConnect(event:Event):void {
            trace("[Socket] connected: " + event);
            trace("  - connected    :", _socket.connected);
            PLATFORM::DESKTOP {
                trace("  - localAddress :", _socket.localAddress);
                trace("  - localPort    :", _socket.localPort);
                trace("  - remoteAddress:", _socket.remoteAddress);
                trace("  - remotePort   :", _socket.remotePort);
            }

            _sendMessage("connected.");
        }

        private function _onSocketIOError(event:IOErrorEvent):void {
            trace("[Socket] IO Error: " + event);
        }

        private function _onSocketSecurityError(event:SecurityErrorEvent):void {
            trace("[Socket] Security Error: " + event);
        }

        private function _sendMessage(message:String):void {
            if (!_socket || !_socket.connected) { return; }

            _socket.writeUTF(message);
            _socket.flush();
        }

        private function _initButtons():void {
            var button_1:PigmyButton = new PigmyButton(_onButtonClick_1, "Send Msg 1");
            var button_2:PigmyButton = new PigmyButton(_onButtonClick_2, "Send Msg 2");
            button_2.y += 60;

            addChild(button_1);
            addChild(button_2);
        }

        private function _onButtonClick_1(event:MouseEvent):void {
            _sendMessage("Message 1");
        }

        private function _onButtonClick_2(event:MouseEvent):void {
            _sendMessage("Message 2");
        }

    }
}
