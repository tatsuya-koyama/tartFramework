package tartlab.data_structures {

    public interface IIterator {

        function start():void;
        function head():*;
        function current():*;
        function next():*;
        function hasNext():Boolean;

    }
}
