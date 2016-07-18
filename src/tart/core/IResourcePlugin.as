package tart.core {

    import tart.core_internal.ResourceRepository;

    public interface IResourcePlugin {

        function afterLoad(resourcesNewlyLoaded:Array,
                           tartResource:TartResource,
                           resourceRepo:ResourceRepository):void;

        function beforeRelease(keysNoLongerUsed:Vector.<String>,
                               tartResource:TartResource,
                               resourceRepo:ResourceRepository):void;

        function findResource(key:String,
                              tartResource:TartResource,
                              resourceRepo:ResourceRepository):*;

    }
}
