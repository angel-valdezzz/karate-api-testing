package examples;
    import com.intuit.karate.junit5.Karate;
    class UsersApiTest { @Karate.Test Karate users() { return Karate.run("users").relativeTo(getClass()); } }
