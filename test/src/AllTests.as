package {

    import tests.SampleTests;
    import tests.dessert_knife.BasicTests;
    import tests.dessert_knife.blades.RandomKnifeTests;
    import tests.dessert_knife.tools.AwaitTests;
    import tests.dessert_knife.tools.AsyncTests;
    import tests.dessert_knife.tools.DeferTests;
    import tests.dessert_knife.tools.DeferredTests;
    import tests.dessert_knife.tools.PromiseTests;

    [Suite]
    public class AllTests {

        public var sampleTests:SampleTests;
        public var knife_basicTests:BasicTests;
        public var knife_blades_randomKnifeTests:RandomKnifeTests;
        public var knife_tools_awaitTests:AwaitTests;
        public var knife_tools_asyncTests:AsyncTests;
        public var knife_tools_deferTests:DeferTests;
        public var knife_tools_deferredTests:DeferredTests;
        public var knife_tools_promiseTests:PromiseTests;

    }
}
