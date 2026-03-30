package template.user;

import com.intuit.karate.junit5.Karate;

class CreateUserRunner {

    @Karate.Test
    Karate testCreateUser() {
        return Karate.run("create-user.feature").relativeTo(getClass());
    }
}
