package template.user;

import com.intuit.karate.junit5.Karate;

class UserRunner {

    @Karate.Test
    Karate testUser() {
        return Karate.run().relativeTo(getClass());
    }
}
