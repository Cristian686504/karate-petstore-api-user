package template.user;

import com.intuit.karate.junit5.Karate;

class GetUpdatedUserRunner {

    @Karate.Test
    Karate testGetUpdatedUser() {
        return Karate.run("get-updated-user.feature").relativeTo(getClass());
    }
}
