package template.user;

import com.intuit.karate.junit5.Karate;

class GetUserRunner {

    @Karate.Test
    Karate testGetUser() {
        return Karate.run("get-user.feature").relativeTo(getClass());
    }
}
