package tart.core {

    import flash.utils.Dictionary;
    import flash.utils.getQualifiedClassName;

    import dessert_knife.knife;
    import dessert_knife.tools.async.Defer;

    public class TartDirector {

        private var _tartContext:TartContext;
        private var _currentScene:TartScene;
        private var _nextScene:TartScene;
        private var _isUnderTransition:Boolean;
        private var _globalChapter:TartChapter;
        private var _sceneToChapter:Dictionary;    // Scene class name -> Chapter instance that Scene belongs to
        private var _chapterToChapter:Dictionary;  // Chapter instance -> Parent Chapter instance
        private var _chapterToScenes:Dictionary;   // Chapter instance -> [Child Scene class name list]

        public function TartDirector(tartContext:TartContext,
                                     firstScene:TartScene, globalChapter:TartChapter=null)
        {
            _tartContext       = tartContext;
            _currentScene      = null;
            _nextScene         = firstScene;
            _isUnderTransition = false;
            _globalChapter     = globalChapter;
            _sceneToChapter    = new Dictionary();
            _chapterToChapter  = new Dictionary();
            _chapterToScenes   = new Dictionary();
        }

        //----------------------------------------------------------------------
        // public
        //----------------------------------------------------------------------

        public function setNextScene(scene:TartScene):void {
            if (_nextScene) {
                TART::LOG_WARN {
                    trace("[Warn :: TartDirector] setNextScene: Multiple Request.",
                          getQualifiedClassName(_nextScene), "is already requested, so",
                          getQualifiedClassName(scene), "is rejected.");
                }
                return;
            }
            _nextScene = scene;
        }

        /** @private */
        public function setup():void {
            if (!_globalChapter) { return; }
            _registerChapters(_globalChapter);
            _groupByChapters();

            TART::LOG_DEBUG {
                debug_dumpSceneMap();
                debug_dumpChapterMap();
                debug_dumpChapterTree();
            }
        }

        /** @private */
        public function processTransition():void {
            if (!_nextScene) { return; }

            if (_isUnderTransition) { return; }
            _isUnderTransition = true;

            var startingScope:ISceneScope = _currentScene || _globalChapter;
            _transitFrom(startingScope, _nextScene).then(function():void {
                _currentScene = _nextScene;
                _nextScene    = null;
                _isUnderTransition = false;
            });
        }

        //----------------------------------------------------------------------
        // private
        //----------------------------------------------------------------------

        private function _registerChapters(chapter:TartChapter):void {
            _mapSceneToChapter(chapter.scenes(), chapter);
            _mapChapterToChapter(chapter.getChapters(), chapter);

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

            throw new Error(sceneName + " is already registered to Chapter:" +
                            _sceneToChapter[sceneName].name +
                            ", so cannot register to: " + chapter.name
                           );
        }

        private function _mapChapterToChapter(childChapters:Vector.<TartChapter>,
                                              parentChapter:TartChapter):void
        {
            if (!childChapters) { return; }

            for each (var childChapter:TartChapter in childChapters) {
                _validate_mapChapterToChapter(childChapter, parentChapter);
                _chapterToChapter[childChapter] = parentChapter;
            }
        }

        private function _validate_mapChapterToChapter(childChapter:TartChapter,
                                                       parentChapter:TartChapter):void
        {
            if (!_chapterToChapter[childChapter]) { return; }

            throw new Error(childChapter.name + " is already registered to Chapter:" +
                            _chapterToChapter[childChapter].name +
                            ", so cannot register to: " + parentChapter.name
                           );
        }

        private function _groupByChapters():void {
            for (var sceneName:String in _sceneToChapter) {
                var chapter:TartChapter = _sceneToChapter[sceneName];
                if (!_chapterToScenes[chapter]) {
                    _chapterToScenes[chapter] = [];
                }
                _chapterToScenes[chapter].push(sceneName);
            }
        }

        /**
         * Exit current Scene and then enter next Scene. If Chapter is changed,
         * the processing sequence is as follows:
         *
         *     - Exit scopes:
         *         -  Exit current Scene
         *         -  Exit current Chapter
         *         - (Exit wide-scope Chapter if needed)
         *
         *     - Enter scopes:
         *         -  Enter next Chapter
         *         - (Enter narrow-scope Chapter if needed)
         *         -  Enter next Scene
         */
        private function _transitFrom(oldScope:ISceneScope, newScope:ISceneScope):Defer {
            // 今見ている Chapter 直下にある場合は遷移完了
            if (_chapterContainsScene(oldScope, newScope)) {
                return _enterScopeAsync(newScope);
            }

            // Chapter から子の Chapter 内に向かうケース
            var childScope:ISceneScope = _getTargetChildScope(oldScope, newScope);
            if (childScope) {
                return _enterScopeAsync(childScope)
                    .then(function():Defer {
                        return _transitFrom(childScope, newScope);
                    });
            }

            // 行き先が子の中に無ければ 1 つ外に出る
            var parentScope:ISceneScope = _getParentScope(oldScope);
            if (parentScope) {
                return _exitScopeAsync(oldScope)
                    .then(function():Defer {
                        return _transitFrom(parentScope, newScope);
                    });
            }

            // 所属 Chapter が見つからなかった場合は
            // 遷移元 Scene が未登録ということなので root から辿り直す
            if (oldScope != _globalChapter) {
                return _exitScopeAsync(oldScope)
                    .then(function():Defer {
                        return _transitFrom(_globalChapter, newScope);
                    });
            }

            // root の Chapter まで辿って行き先が見つからなかった場合は
            // 遷移先 Scene が未登録のものなのでそのまま遷移
            return _enterScopeAsync(newScope);
        }

        private function _getTargetChildScope(scope:ISceneScope,
                                              targetScope:ISceneScope):ISceneScope
        {
            if (!scope) { return null; }

            var children:Vector.<ISceneScope> = scope.getChildren();
            if (!children) { return null; }
            // Scene は子を持たないので、以下、scope == TartChapter のケース

            for each (var childScope_1:ISceneScope in children) {
                if (_chapterContainsScene(childScope_1, targetScope)) {
                    return childScope_1;
                }
            }

            for each (var childScope_2:ISceneScope in children) {
                var found:ISceneScope = _getTargetChildScope(childScope_2, targetScope);
                if (found) { return childScope_2; }
            }
            return null;
        }

        private function _chapterContainsScene(chapter:ISceneScope, scene:ISceneScope):Boolean {
            if (!(chapter is TartChapter)) { return false; }

            var sceneNames:Array = _chapterToScenes[chapter];
            if (!sceneNames) { return false; }

            var targetSceneName:String = getQualifiedClassName(scene);
            return sceneNames.indexOf(targetSceneName) >= 0;
        }

        private function _getParentScope(scope:ISceneScope):ISceneScope {
            // Scene
            if (scope is TartScene) {
                var sceneName:String = getQualifiedClassName(scope);
                return _sceneToChapter[sceneName];
            }

            // Chapter
            return _chapterToChapter[scope];
        }

        private function _enterScopeAsync(scope:ISceneScope):Defer {
            TART::LOG_DEBUG {
                trace("[Debug :: TartDirector] --> Enter:",
                      getQualifiedClassName(scope));
            }

            scope.awake();
            return _loadScopeResourceAsync(scope)
                .then(scope.initAsync)
                .then(function():void { scope.init(); })
                .then(function():void { _createInitialActors(scope); });
        }

        private function _loadScopeResourceAsync(scope:ISceneScope):Defer {
            trace("ToDo: load resource");
            return knife.defer().done();
        }

        private function _createInitialActors(scope:ISceneScope):void {
            var actors:Array = scope.initialActors();
            if (!actors) { return; }

            var engine:TartEngine = _tartContext.engine;
            for each (var actor:TartActor in actors) {
                engine.createActor(actor, scope);
            }
        }

        private function _exitScopeAsync(scope:ISceneScope):Defer {
            if (!scope) { return knife.defer().done(); }
            TART::LOG_DEBUG {
                trace("[Debug :: TartDirector] *** Exit :",
                      getQualifiedClassName(scope));
            }

            return knife.defer().done()
                .then(scope.disposeAsync)
                .then(function():void { scope.dispose(); })
                .then(function():void { _disposeScopeResource(scope); })
                .then(function():void { _disposeScopeActors(scope); });
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
            trace("[Debug :: TartDirector] ***** {Scene : Parent Chapter} map *****");
            trace(JSON.stringify(obj, null, 4));
        }

        public function debug_dumpChapterMap():void {
            var obj:Object = {};
            for (var key:* in _chapterToChapter) {
                var chapter:TartChapter = key as TartChapter;
                obj[chapter.name] = _chapterToChapter[chapter].name;
            }
            trace("[Debug :: TartDirector] ***** {Chapter : Parent Chapter} map *****");
            trace(JSON.stringify(obj, null, 4));
        }

        public function debug_dumpChapterTree():void {
            var chapters:Object     = {};
            var childrenList:Object = {};
            for (var key:* in _chapterToScenes) {
                var chapter:TartChapter = key as TartChapter;
                chapters[chapter.name] = _chapterToScenes[chapter];

                var children:Vector.<TartChapter> = chapter.getChapters();
                childrenList[chapter.name] = children || [];
            }

            var tree:Object = __makeChapterInfo(_globalChapter.name, chapters, childrenList);
            trace("[Debug :: TartDirector] ***** Chapter tree *****");
            trace(JSON.stringify(tree, null, 4));
        }

        private function __makeChapterInfo(rootName:String, chapters:Object, childrenList:Object):Object {
            var obj:Object = {};
            obj[rootName] = chapters[rootName];
            var children:Vector.<TartChapter> = childrenList[rootName];
            for each (var child:TartChapter in children) {
                obj[rootName].push(
                    __makeChapterInfo(child.name, chapters, childrenList)
                );
            }
            return obj;
        }

    }
}
