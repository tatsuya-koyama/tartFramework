package {

    import flash.display.Sprite;
    import flash.events.Event;
    import flash.system.Capabilities;
    import flash.system.MessageChannel;
    import flash.system.Worker;
    import flash.system.WorkerDomain;
    import flash.utils.ByteArray;
    import flash.utils.setTimeout;

    import tart.core.TartEngine;

    public class Main extends Sprite {

        [Embed(source="../build/WorkerThread.swf", mimeType="application/octet-stream")]
        private static var WORKER_SWF:Class;

        private var _channelToWorker:MessageChannel;
        private var _channelToMain:MessageChannel;

        public function Main() {
            _centeringWindowForDesktopApp();
            _initWorker();
        }

        private function _centeringWindowForDesktopApp():void {
            PLATFORM::DESKTOP {
                stage.nativeWindow.x = (Capabilities.screenResolutionX - stage.nativeWindow.width)  * 0.5;
                stage.nativeWindow.y = (Capabilities.screenResolutionY - stage.nativeWindow.height) * 0.5;
            }
        }

        private function _initWorker():void {
            var workerBytes:ByteArray = new WORKER_SWF() as ByteArray;
            var worker:Worker = WorkerDomain.current.createWorker(workerBytes);

            _channelToWorker = Worker.current.createMessageChannel(worker);
            worker.setSharedProperty("_channelToWorker", _channelToWorker);

            _channelToMain = worker.createMessageChannel(Worker.current);
            _channelToMain.addEventListener(Event.CHANNEL_MESSAGE, _onMessageFromWorker);
            worker.setSharedProperty("_channelToMain", _channelToMain);

            worker.start();

            setTimeout(function():void {
                _channelToWorker.send("Hello");
            }, 1000);
        }

        private function _onMessageFromWorker(event:Event):void {
            var data:* = event.target.receive();
            trace("[Worker -> Main] received:", data);
        }

    }
}
