package template.user;

import com.intuit.karate.junit5.Karate;

class UpdateUserRunner {

    @Karate.Test
    Karate testUpdateUser() {
        return Karate.run("update-user.feature").relativeTo(getClass());
    }
}
