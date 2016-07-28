package tart.core {

    import flash.utils.getQualifiedClassName;

    import dessert_knife.knife;
    import dessert_knife.tools.async.Defer;

    /**
     * Large scope including Scenes.
     */
    public class TartChapter implements ISceneScope {

        private var _tartContext:TartContext;
        private var _chapters:Vector.<TartChapter>;

        public function TartChapter() {
            _chapters = new Vector.<TartChapter>();
        }

        //----------------------------------------------------------------------
        // public
        //----------------------------------------------------------------------

        public function get name():String {
            return getQualifiedClassName(this);
        }

        public function scenes():Array {
            return null;
        }

        public function addChapters(...args):void {
            for (var i:int = 0; i < args.length; ++i) {
                if (!(args[i] is TartChapter)) {
                    throw new Error("[TartChapter :: addChapters] " +
                                    "Object is not TartChapter: " + args[i]);
                }

                var chapter:TartChapter = args[i] as TartChapter;
                _chapters.push(chapter);
            }
        }

        public function getChapters():Vector.<TartChapter> {
            return _chapters;
        }

        //----------------------------------------------------------------------
        // implements ISceneScope
        //----------------------------------------------------------------------

        public function get tart():TartContext {
            return _tartContext;
        }

        public function set tart(tartContext:TartContext):void {
            _tartContext = tartContext;
        }

        public function getChildren():Vector.<ISceneScope> {
            return Vector.<ISceneScope>(_chapters);
        }

        public function awake():void {

        }

        public function initAsync():Defer {
            return knife.defer().done();
        }

        public function init():void {

        }

        public function disposeAsync():Defer {
            return knife.defer().done();
        }

        public function dispose():void {

        }

        public function assets():Array {
            return null;
        }

        public function initialActors():Array {
            return null;
        }

    }
}
