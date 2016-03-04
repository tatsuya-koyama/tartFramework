package tart.core {

    import flash.utils.Dictionary;
    import flash.utils.getQualifiedClassName;

    import dessert_knife.knife;
    import dessert_knife.tools.async.Defer;

    public class TartDirector {

        private var _currentScene:TartScene;
        private var _nextScene:TartScene;
        private var _isUnderTransition:Boolean;
        private var _globalChapter:TartChapter;
        private var _sceneToChapter:Dictionary;  // Scene class name -> Chapter instance that Scene belongs to

        public function TartDirector(firstScene:TartScene, globalChapter:TartChapter=null) {
            _currentScene      = null;
            _nextScene         = firstScene;
            _isUnderTransition = false;
            _globalChapter     = globalChapter;
            _sceneToChapter    = new Dictionary();
        }

        //----------------------------------------------------------------------
        // public
        //----------------------------------------------------------------------

        public function setup():void {
            if (!_globalChapter) { return; }
            _registerChapters(_globalChapter);

            // debugging...
            debug_dumpSceneMap();
            debug_dumpScopes();
        }

        /** @private */
        public function processTransition():void {
            if (!_nextScene) { return; }
            if (_isUnderTransition) { return; }

            _isUnderTransition = true;
            // ToDo...
        }

        //----------------------------------------------------------------------
        // private
        //----------------------------------------------------------------------

        private function _registerChapters(chapter:TartChapter):void {
            _mapSceneToChapter(chapter.scenes(), chapter);

            var chapterChildren:Vector.<TartChapter> = chapter.getChapters();
            if (!chapterChildren) { return; }

            for each (var chapter:TartChapter in chapterChildren) {
                _registerChapters(chapter);
            }
        }

        private function _mapSceneToChapter(sceneClasses:Array, chapter:TartChapter):void {
            if (!sceneClasses) { return; }

            for each (var sceneClass:Class in sceneClasses) {
                var sceneName:String = getQualifiedClassName(sceneClass);
                _validate_mapSceneToChapter(sceneName, chapter);
                _sceneToChapter[sceneName] = chapter;
            }
        }

        private function _validate_mapSceneToChapter(sceneName:String, chapter:TartChapter):void {
            if (!_sceneToChapter[sceneName]) { return; }

            throw new Error("[TartChapter :: _mapSceneToChapter] " +
                            sceneName + " is already registered to Chapter:" +
                            _sceneToChapter[sceneName].name +
                            ", so cannot register to: " + chapter.name
                           );
        }

        private function _enterScopeAsync(scope:ISceneScope):Defer {
            scope.awake();
            return _loadScopeResourceAsync(scope)
                .then(scope.initAsync)
                .then(scope.init)
                .then(function():void {
                    _createInitialActors(scope);
                });
        }

        private function _loadScopeResourceAsync(scope:ISceneScope):Defer {
            trace("ToDo: load resource");
            return knife.defer().done();
        }

        private function _createInitialActors(scope:ISceneScope):void {
            trace("ToDo: create initial actors");
        }

        private function _exitScopeAsync(scope:ISceneScope):Defer {
            if (!scope) { return knife.defer().done(); }

            return scope.disposeAsync()
                .then(scope.dispose)
                .then(function():void {
                    _disposeScopeResource(scope);
                })
                .then(function():void {
                    _disposeScopeActors(scope);
                });
        }

        private function _disposeScopeResource(scope:ISceneScope):void {
            trace("ToDo: dispose resource");
        }

        private function _disposeScopeActors(scope:ISceneScope):void {
            trace("ToDo: dispose scope actors");
        }

        //----------------------------------------------------------------------
        // debug commands
        //----------------------------------------------------------------------

        public function debug_dumpSceneMap():void {
            var obj:Object = {};
            for (var sceneName:String in _sceneToChapter) {
                obj[sceneName] = _sceneToChapter[sceneName].name;
            }
            trace("***** Scene - Chapter map *****");
            trace(JSON.stringify(obj, null, 4));
        }

        public function debug_dumpScopes():void {
            var chapters:Object = {};
            for (var sceneName:String in _sceneToChapter) {
                var chapterName:String = _sceneToChapter[sceneName].name;
                if (!chapters[chapterName]) {
                    chapters[chapterName] = [];
                }
                chapters[chapterName].push(sceneName);
            }
            trace("***** Chapter list *****");
            trace(JSON.stringify(chapters, null, 4));
        }

        public function debug_dumpChapterTree():void {
            // ToDo
        }

    }
}
