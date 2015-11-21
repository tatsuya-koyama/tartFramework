package {

    import tests.SampleTests;
    import tests.dessert_knife.BasicTests;
    import tests.dessert_knife.tools.AwaitTests;
    import tests.dessert_knife.tools.AsyncTests;

    [Suite]
    public class AllTests {

        public var sampleTests:SampleTests;
        public var knife_basicTests:BasicTests;
        public var knife_tools_awaitTests:AwaitTests;
        public var knife_tools_asyncTests:AsyncTests;

    }
}
