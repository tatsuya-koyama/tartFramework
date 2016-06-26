package {

    import tests.SampleTests;
    import tests.dessert_knife.BasicTests;
    import tests.dessert_knife.blades.RandomKnifeTests;
    import tests.dessert_knife.blades.StringKnifeTests;
    import tests.dessert_knife.tools.async.AwaitTests;
    import tests.dessert_knife.tools.async.AsyncTests;
    import tests.dessert_knife.tools.async.DeferTests;
    import tests.dessert_knife.tools.async.DeferredTests;
    import tests.dessert_knife.tools.async.PromiseTests;

    [Suite]
    public class AllTests {

        public var sampleTests:SampleTests;
        public var knife_basicTests:BasicTests;
        public var knife_blades_randomKnifeTests:RandomKnifeTests;
        public var knife_blades_stringKnifeTests:StringKnifeTests;
        public var knife_tools_awaitTests:AwaitTests;
        public var knife_tools_asyncTests:AsyncTests;
        public var knife_tools_deferTests:DeferTests;
        public var knife_tools_deferredTests:DeferredTests;
        public var knife_tools_promiseTests:PromiseTests;

    }
}
