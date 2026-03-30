package template.user;

import com.intuit.karate.junit5.Karate;

class DeleteUserRunner {

    @Karate.Test
    Karate testDeleteUser() {
        return Karate.run("delete-user.feature").relativeTo(getClass());
    }
}
